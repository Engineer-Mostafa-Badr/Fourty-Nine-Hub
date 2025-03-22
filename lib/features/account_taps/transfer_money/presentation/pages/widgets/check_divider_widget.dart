import 'package:flutter/material.dart';

class CheckDividerWidget extends StatelessWidget {
  const CheckDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFD9D9D9),
            thickness: 2,
            height: 0,
          ),
        ),
        CircleAvatar(
          radius: 15,
          backgroundColor: Color(0xFFD9D9D9),
          child: Icon(
            Icons.check,
            color: Colors.green,
            size: 22,
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFD9D9D9),
            thickness: 2,
            height: 0,
          ),
        ),
      ],
    );
  }
}