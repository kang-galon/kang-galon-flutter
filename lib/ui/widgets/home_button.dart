import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onPressed;
  final bool isDense;

  CustomIconButton({
    @required this.label,
    @required this.icon,
    @required this.onPressed,
    this.isDense = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: isDense
            ? MaterialStateProperty.all<Size>(Size(60.0, 60.0))
            : MaterialStateProperty.all<Size>(Size(100.0, 60.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              child: Icon(icon),
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
