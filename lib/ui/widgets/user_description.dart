import 'package:flutter/material.dart';
import 'package:kang_galon/ui/pages/pages.dart';

class UserDescription extends StatelessWidget {
  final Function() onTap;
  final String name;

  UserDescription({
    @required this.onTap,
    @required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 65.0,
          decoration: Style.containerDecoration,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Container(
            height: 65.0,
            padding: const EdgeInsets.all(20.0),
            decoration: Style.containerDecoration,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Hai, ',
                  style: const TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
