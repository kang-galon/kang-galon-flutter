import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  void initializeFlutterFire() async {
    try {
      var duration = Duration(seconds: 3);

      await Firebase.initializeApp();

      Timer(duration, () {
        setState(() {
          _initialized = true;
        });
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
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
        ],
        child: MaterialApp(home: LoginPage()),
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
        ],
        child: MaterialApp(home: HomePage()),
      );
    }
  }
}
