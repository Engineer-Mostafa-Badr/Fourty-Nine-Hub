import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AppInfoText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final double? iconHeight;
  const AppInfoText({super.key, required this.text, this.textStyle, this.iconHeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          Assets.icon,
          height:iconHeight?? 30,
        ),
        Expanded(
          child: Text(
            text,
            style: textStyle?? Styles.mediumText(),
          ),
        )
      ],
    );
  }
}
