import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class IconAndHintWidget extends StatelessWidget {
  const IconAndHintWidget({
    super.key,
    required this.text,
    this.textStyle,
  });

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.alertIcon),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Label(
            text: text,
            style: textStyle ?? Styles.mediumText(fontSize: 20),
          ),
        )
      ],
    );
  }
}
