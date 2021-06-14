import 'package:flutter/material.dart';

class Pallette {
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

  static final EdgeInsets contentPadding =
      const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0);

  static final Color shimmerBaseColor = Colors.grey.shade300;

  static final Color shimmerHighlightColor = Colors.grey.shade100;
}
