import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/arguments/arguments.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _initialized;
  bool _error;

  @override
  void initState() {
    super.initState();

    _initialized = false;
    _error = false;

    splashTimer();
  }

  void splashTimer() async {
    try {
      var duration = Duration(seconds: 3);

      await Firebase.initializeApp();

      Timer(duration, () {
        setState(() => _initialized = true);
      });
    } catch (e) {
      setState(() => _error = true);
    }
  }

  Map<String, Widget Function(BuildContext)> get _routes => {
        AccountPage.routeName: (_) => AccountPage(),
        ChatsPage.routeName: (_) => ChatsPage(),
        HistoryPage.routeName: (_) => HistoryPage(),
        HomePage.routeName: (_) => HomePage(),
        LoginPage.routeName: (_) => LoginPage(),
        MapsPage.routeName: (_) => MapsPage(),
        NearDepotPage.routeName: (_) => NearDepotPage(),
        RegisterPage.routeName: (_) => RegisterPage(),
      };

  Route _buildOnGenerateRoute(RouteSettings settings) {
    if (settings.name == DepotPage.routeName)
      return MaterialPageRoute(builder: (context) {
        final DepotArguments args = settings.arguments as DepotArguments;

        return DepotPage(depot: args.depot);
      });

    if (settings.name == TransactionPage.routeName)
      return MaterialPageRoute(builder: (context) {
        final TransactionArguments args =
            settings.arguments as TransactionArguments;

        return TransactionPage(id: args.id);
      });

    if (settings.name == VerificationOtpPage.routeName)
      return MaterialPageRoute(builder: (context) {
        final VerificationOtpArguments args =
            settings.arguments as VerificationOtpArguments;

        return VerificationOtpPage(
          name: args.name,
          phoneNumber: args.phoneNumber,
          verificationId: args.verificationId,
          isLogin: args.isLogin,
        );
      });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      showSnackbar(context, 'Something wrong, when initialize FlutterFire');
    }

    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Container(
              child: Text('Kang Galon'),
            ),
          ),
        ),
      );
    }

    // Check if already login or not
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    if (user == null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(create: (context) => UserBloc()),
          BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
          BlocProvider<DepotBloc>(create: (context) => DepotBloc()),
          BlocProvider<TransactionBloc>(create: (context) => TransactionBloc()),
          BlocProvider<TransactionDetailBloc>(
              create: (context) => TransactionDetailBloc()),
          BlocProvider<TransactionCurrentBloc>(
              create: (context) => TransactionCurrentBloc()),
          BlocProvider<ChatsBloc>(create: (context) => ChatsBloc()),
        ],
        child: MaterialApp(
          routes: _routes,
          initialRoute: LoginPage.routeName,
          onGenerateRoute: (settings) => _buildOnGenerateRoute(settings),
        ),
      );
    } else {
      return MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>(create: (context) => UserBloc.currentUser()),
          BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
          BlocProvider<DepotBloc>(create: (context) => DepotBloc()),
          BlocProvider<TransactionBloc>(create: (context) => TransactionBloc()),
          BlocProvider<TransactionDetailBloc>(
              create: (context) => TransactionDetailBloc()),
          BlocProvider<TransactionCurrentBloc>(
              create: (context) => TransactionCurrentBloc()),
          BlocProvider<ChatsBloc>(create: (context) => ChatsBloc()),
        ],
        child: MaterialApp(
          routes: _routes,
          initialRoute: HomePage.routeName,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
          ),
          onGenerateRoute: (settings) => _buildOnGenerateRoute(settings),
        ),
      );
    }
  }
}
