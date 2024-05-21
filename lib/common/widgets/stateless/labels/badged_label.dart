import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'label.dart';

class BadgedLabel extends StatelessWidget {
  final Color color, textColor;
  final String label;
  final double radius;

  const BadgedLabel(
      {super.key,
      this.color = AppColors.PRIMARY_COLOR,
      required this.label,
      this.radius = 10,
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: Label(text: label, style: Styles.mediumText(color: textColor)),
    );
  }
}
