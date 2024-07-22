import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorLoginInfoText extends StatelessWidget {
  final String text;
  const DoctorLoginInfoText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          Assets.icon,
          height: 30,
        ),
        Expanded(
          child: Text(
            text,
            style: Styles.mediumText(),
          ),
        )
      ],
    );
  }
}
