import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kang_galon/core/viewmodels/bloc.dart';
import 'package:kang_galon/ui/pages/pages.dart';
import 'package:kang_galon/ui/widgets/widgets.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.max,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

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
    splashTimer();
  }

  void splashTimer() async {
    try {
      var duration = Duration(seconds: 3);

      await Firebase.initializeApp();

      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         AndroidFlutterLocalNotificationsPlugin>()
      //     ?.createNotificationChannel(channel);

      // var initializationSettingAndroid =
      //     AndroidInitializationSettings('@mipmap/ic_launcher');
      // var initializationSettings =
      //     InitializationSettings(android: initializationSettingAndroid);

      // flutterLocalNotificationsPlugin.initialize(initializationSettings);
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   RemoteNotification notification = message.notification;
      //   AndroidNotification android = message.notification?.android;

      //   if (notification != null && android != null) {
      //     flutterLocalNotificationsPlugin.show(
      //         notification.hashCode,
      //         notification.title,
      //         notification.body,
      //         NotificationDetails(
      //           android: AndroidNotificationDetails(
      //             channel.id,
      //             channel.name,
      //             channel.description,
      //             icon: android?.smallIcon,
      //             // other properties...
      //           ),
      //         ));
      //   }
      // });

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
          BlocProvider<ChatsBloc>(create: (context) => ChatsBloc()),
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
          BlocProvider<ChatsBloc>(create: (context) => ChatsBloc()),
        ],
        child: MaterialApp(home: HomePage()),
      );
    }
  }
}
