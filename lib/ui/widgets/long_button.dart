import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LongButton extends StatelessWidget {
  final BuildContext context;
  final void Function() onPressed;
  final IconData icon;
  final String text;

  LongButton({
    @required this.context,
    @required this.onPressed,
    @required this.icon,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: this.onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        elevation: MaterialStateProperty.all<double>(2.0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(this.icon),
            Text(
              this.text,
              textAlign: TextAlign.center,
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
