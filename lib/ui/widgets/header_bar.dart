import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String label;

  HeaderBar({
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          child: Icon(
            Icons.chevron_left,
            size: 30.0,
          ),
          shape: CircleBorder(),
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          elevation: 5.0,
          onPressed: () => Navigator.pop(context),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 2.0,
                  blurRadius: 2.0,
                  offset: Offset(1, 2),
                )
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
