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
      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0);
}
