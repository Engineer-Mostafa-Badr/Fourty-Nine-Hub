import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

abstract class Styles {
// text
  static TextStyle smallText(
      {double fontSize = 22,
      Color? color,
      TextDecoration? decoration,
      double decorationThickness = 0,
      List<Shadow>? shadows,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize.sp,
        color: color,
        decorationThickness: decorationThickness,
        decoration: decoration,
        shadows: shadows,
        decorationColor: color ?? AppColors.PRIMARY_COLOR,
        fontWeight: fontWeight);
  }

  static TextStyle mediumText(
      {double fontSize = 28,
      Color? color,
      double decorationThickness = 0,
      TextDecoration? decoration,
      List<Shadow>? shadows,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize.sp,
        color: color,
        // overflow: TextOverflow.ellipsis,
        shadows: shadows,
        decorationThickness: decorationThickness,
        decoration: decoration,
        fontWeight: fontWeight);
  }

  static TextStyle headerText(
      {double fontSize = 36,
      TextDecoration? decoration,
      TextAlign textAlign = TextAlign.center,
      List<Shadow>? shadows,
      double decorationThickness = 0,
      Color? color,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      shadows: shadows,
      decorationColor: color,
      decoration: decoration,
      color: color,
      decorationThickness: decorationThickness,
    );
  }
}
