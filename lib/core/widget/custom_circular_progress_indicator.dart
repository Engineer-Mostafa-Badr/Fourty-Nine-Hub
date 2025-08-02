import 'package:flutter/material.dart';

import '../../res/assets/assets.dart';
import 'package:lottie/lottie.dart';

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
    return  Lottie.asset(
      Assets.customLoading,
      // width: value,
      // height: value,
      width: 50,
      height: 50,
      fit: BoxFit.fill,
    );
    // CircularProgressIndicator(
    //   color: color ?? AppColors.getButtonPrimaryWhiteColor(context),
    //   value: value,
    //   strokeWidth: strokeWidth ?? 4,
    //   valueColor: valueColor,
    //   backgroundColor: backgroundColor,
    // );
  }
}
