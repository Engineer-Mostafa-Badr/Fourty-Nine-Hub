import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class IconAndHintWidget extends StatelessWidget {
  const IconAndHintWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.alertIcon),
        const SizedBox(
          width: 8,
        ),
        Label(
          text: text,
          style: Styles.mediumText(fontSize: 20),
        )
      ],
    );
  }
}
