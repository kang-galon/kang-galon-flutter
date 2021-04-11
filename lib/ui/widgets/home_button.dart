import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  String label;
  IconData icon;
  void Function() onPressed;

  HomeButton({
    @required this.label,
    @required this.icon,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(100.0, 60.0)),
      ),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Container(
              child: Icon(this.icon),
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
            ),
            Text(this.label),
          ],
        ),
      ),
    );
  }
}
