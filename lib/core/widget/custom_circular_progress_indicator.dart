import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator(
      {super.key, this.value, this.color, this.strokeWidth, this.valueColor, this.backgroundColor});

  final double? value;
  final Color? color;
  final double? strokeWidth;
final Animation<Color?>? valueColor;
final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? AppColors.getButtonPrimaryWhiteColor(context),
      value: value,
      strokeWidth: strokeWidth ?? 4,
      valueColor: valueColor,
      backgroundColor: backgroundColor,
    );
  }
}
