export 'account_page.dart';
export 'depot_page.dart';
export 'home_page.dart';
export 'login_page.dart';
export 'maps_page.dart';
export 'near_depot_page.dart';
export 'register_page.dart';
export 'splash_page.dart';
export 'verification_otp_page.dart';
export 'history_page.dart';
export 'transaction_page.dart';

import 'package:flutter/material.dart';

class Style {
  static final BoxDecoration containerDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.shade300,
        spreadRadius: 2.0,
        blurRadius: 2.0,
        offset: Offset(1, 2),
      )
    ],
  );

  static final EdgeInsets mainPadding =
      EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0, bottom: 30.0);
}
