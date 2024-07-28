import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorInfoText extends StatelessWidget {
  final String text;
  const CreateDoctorInfoText({super.key, required this.text});

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
