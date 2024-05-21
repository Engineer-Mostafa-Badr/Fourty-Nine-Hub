import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../labels/label.dart';

class ElevatedAppButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final IconData? icon;
  final double? radius;

  const ElevatedAppButton({
    super.key,
    this.radius,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.PRIMARY_COLOR,
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
                    text: label, style: Styles.mediumText(color: Colors.white))
              ]),
            )
          : Label(text: label, style: Styles.mediumText(color: Colors.white)),
    );
  }
}
