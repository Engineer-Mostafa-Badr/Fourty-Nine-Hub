import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
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
            maxLines: 2,
            style: textStyle ??
                Styles.mediumText(
                  fontSize: 20,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
          ),
        )
      ],
    );
  }
}
