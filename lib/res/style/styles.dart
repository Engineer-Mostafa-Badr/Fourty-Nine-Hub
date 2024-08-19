import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

abstract class Styles {
// text
  static TextStyle smallText(
      {double fontSize = 10,
      Color color = AppColors.PRIMARY_COLOR,
      TextDecoration? decoration,
      List<Shadow>? shadows,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration,
        shadows: shadows,
        decorationColor: color,
        fontWeight: fontWeight);
  }

  static TextStyle mediumText(
      {double fontSize = 12,
      Color? color,
      TextDecoration? decoration,
      List<Shadow>? shadows,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        // overflow: TextOverflow.ellipsis,
        shadows: shadows,
        decoration: decoration,
        fontWeight: fontWeight);
  }

  static TextStyle headerText(
      {double fontSize = 16,
      TextDecoration? decoration,
      TextAlign textAlign = TextAlign.center,
      List<Shadow>? shadows,
      Color? color,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: shadows,
        color: color);
  }
}
