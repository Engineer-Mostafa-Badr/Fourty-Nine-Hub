import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

abstract class Styles {
// text
  static TextStyle smallText(
      {double fontSize = 22,
      Color? color,
      TextDecoration? decoration,
      List<Shadow>? shadows,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize.zSP,
        color: color ,
        decoration: decoration,
        shadows: shadows,
        decorationColor: color ?? AppColors.PRIMARY_COLOR,
        fontWeight: fontWeight);
  }

  static TextStyle mediumText(
      {double fontSize = 28,
      Color? color,
      TextDecoration? decoration,
      List<Shadow>? shadows,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize.zSP,
        color: color ,
        // overflow: TextOverflow.ellipsis,
        shadows: shadows,
        decoration: decoration,
        fontWeight: fontWeight);
  }

  static TextStyle headerText(
      {double fontSize = 36,
      TextDecoration? decoration,
      TextAlign textAlign = TextAlign.center,
      List<Shadow>? shadows,
      Color? color,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
        fontSize: fontSize.zSP,
        fontWeight: fontWeight,
        shadows: shadows,
        decorationColor: color,
        color: color);
  }
}
