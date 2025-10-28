import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract class Styles {
// text
  static TextStyle smallText(
      {double fontSize = 22,
      Color? color,
      TextDecoration? decoration,
      double decorationThickness = 0,
      List<Shadow>? shadows,
      double? height,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: fontSize.sp,
      color: color,
      decorationThickness: decoration != null ? decorationThickness : null,
      decoration: decoration,
      shadows: shadows,
      decorationColor: decoration != null ? (color ?? AppColors.PRIMARY_COLOR) : null,
      fontWeight: fontWeight,
      height: height,
    );
  }

  static TextStyle mediumText(
      {double fontSize = 28,
      Color? color,
      double decorationThickness = 0,
      TextDecoration? decoration,
      List<Shadow>? shadows,
      FontStyle? fontStyle,
      double? height,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
      fontSize: fontSize.sp,
      color: color,
      fontStyle: fontStyle,
      // overflow: TextOverflow.ellipsis,
      shadows: shadows,
      decorationThickness: decoration != null ? decorationThickness : null,
      decoration: decoration,
      decorationColor: decoration != null ? color : null,
      fontWeight: fontWeight,
      height: height,
    );
  }

  static TextStyle headerText(
      {double fontSize = 36,
      TextDecoration? decoration,
      TextAlign textAlign = TextAlign.center,
      List<Shadow>? shadows,
      double decorationThickness = 0,
      Color? color,
      double? height,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
      fontSize: (fontSize??36).sp,
      fontWeight: fontWeight,
      shadows: shadows,
      decorationColor: decoration != null ? color : null,
      decoration: decoration,
      color: color,
      decorationThickness: decoration != null ? decorationThickness : null,
      height: height,
    );
  }
}
