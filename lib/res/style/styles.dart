import 'package:flutter/material.dart';

abstract class Styles {
// text
  static TextStyle smallText(
      {double fontSize = 10,
      Color color = Colors.black,
      TextDecoration? decoration,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: decoration,
        fontWeight: fontWeight);
  }

  static TextStyle mediumText(
      {double fontSize = 12,
      Color color = Colors.black,
      TextDecoration? decoration,
      FontWeight fontWeight = FontWeight.w400}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        // overflow: TextOverflow.ellipsis,
        decoration: decoration,
        fontWeight: fontWeight);
  }

  static TextStyle headerText(
      {double fontSize = 16,
      TextDecoration? decoration,
      TextAlign textAlign = TextAlign.center,
      Color color = Colors.black,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight);
  }
}
