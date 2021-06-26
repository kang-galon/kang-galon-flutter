import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/blocs/event_state.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/snackbar.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SnackbarBloc _snackbarBloc;
  late bool _initialized;

  @override
  void initState() {
    // init
    _snackbarBloc = SnackbarBloc();
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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    return MultiBlocProvider(
      providers: [
        BlocProvider<SnackbarBloc>(create: (_) => _snackbarBloc),
        BlocProvider<LocationBloc>(create: (_) => LocationBloc(_snackbarBloc)),
        BlocProvider<DepotBloc>(create: (_) => DepotBloc(_snackbarBloc)),
        BlocProvider<TransactionBloc>(
            create: (_) => TransactionBloc(_snackbarBloc)),
        BlocProvider<TransactionDetailBloc>(
            create: (_) => TransactionDetailBloc(_snackbarBloc)),
        BlocProvider<TransactionCurrentBloc>(
            create: (_) => TransactionCurrentBloc(_snackbarBloc)),
        BlocProvider<ChatsBloc>(create: (_) => ChatsBloc(_snackbarBloc)),
      ]..add(
          user == null // user bloc
              ? BlocProvider<UserBloc>(create: (_) => UserBloc(_snackbarBloc))
              : BlocProvider<UserBloc>(
                  create: (_) => UserBloc.currentUser(_snackbarBloc)),
        ),
      child: MaterialApp(
        title: 'Kang Galon',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: BlocListener<SnackbarBloc, SnackbarState>(
          listener: (context, state) {
            if (state is SnackbarShowing) {
              showSnackbar(context, state.message, isError: state.isError);
            }
          },
          child: user == null ? LoginPage() : HomePage(),
        ),
      ),
    );
  }
}
