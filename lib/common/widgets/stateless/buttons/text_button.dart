import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class TextAppButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData? icon;
  final double? radius;
  final TextStyle? style;

  const TextAppButton(
      {super.key,
      this.radius,
      this.style,
      required this.label,
      required this.onPressed,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: icon != null
          ? RichText(
              text: TextSpan(children: [
                WidgetSpan(
                    child: Icon(
                  icon,
                  color: Colors.white,
                )),
                TextSpan(
                    text: label,
                    style: Styles.mediumText(color: AppColors.PRIMARY_COLOR))
              ]),
            )
          : Label(
              text: label,
              style: style ??
                  Styles.mediumText(
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w700)),
    );
  }
}
