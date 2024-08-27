import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class ElevatedAppButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData? icon;
  final double? radius;
  final Color? backColor;
  final TextStyle? textStyle;

  const ElevatedAppButton(
      {super.key,
      this.radius,
      required this.label,
      required this.onPressed,
      this.icon,
      this.backColor = AppColors.PRIMARY_COLOR,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: backColor ?? Theme.of(context).primaryColor,
      ),
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
                    style: textStyle ??
                        Styles.mediumText(
                            color: Theme.of(context).scaffoldBackgroundColor))
              ]),
            )
          : Label(
              text: label,
              style: textStyle ??
                  Styles.mediumText(
                      color: Theme.of(context).scaffoldBackgroundColor)),
    );
  }
}
