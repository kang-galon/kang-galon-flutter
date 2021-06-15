import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool _initialized;

  @override
  void initState() {
    _initialized = false;

    super.initState();

    splashTimer();
  }

  void splashTimer() async {
    Duration duration = Duration(seconds: 3);

    Timer(duration, () => setState(() => _initialized = true));
  }

  @override
  Widget build(BuildContext context) {
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

    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(create: (context) => LocationBloc()),
        BlocProvider<DepotBloc>(create: (context) => DepotBloc()),
        BlocProvider<TransactionBloc>(create: (context) => TransactionBloc()),
        BlocProvider<TransactionDetailBloc>(
            create: (context) => TransactionDetailBloc()),
        BlocProvider<TransactionCurrentBloc>(
            create: (context) => TransactionCurrentBloc()),
        BlocProvider<ChatsBloc>(create: (context) => ChatsBloc()),
      ]..add(
          user == null // user bloc
              ? BlocProvider<UserBloc>(create: (context) => UserBloc())
              : BlocProvider<UserBloc>(
                  create: (context) => UserBloc.currentUser()),
        ),
      child: MaterialApp(
        title: 'Kang Galon',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: user == null ? LoginPage() : HomePage(),
      ),
    );
  }
}
