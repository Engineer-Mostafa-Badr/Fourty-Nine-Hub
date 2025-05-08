import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class CheckDividerWidget extends StatelessWidget {
  const CheckDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: context.isDarkMode ? Color(0xff333333) : Color(0xFFD9D9D9),
            thickness: 2,
            height: 0,
          ),
        ),
        CircleAvatar(
          radius: 15,
          backgroundColor:
              context.isDarkMode ? Color(0xff333333) : Color(0xFFD9D9D9),
          child: Icon(
            Icons.check,
            color: context.isDarkMode ? Color(0xff7FDA17) : Colors.green,
            size: 22,
          ),
        ),
        Expanded(
          child: Divider(
            color: context.isDarkMode ? Color(0xff333333) : Color(0xFFD9D9D9),
            thickness: 2,
            height: 0,
          ),
        ),
      ],
    );
  }
}
