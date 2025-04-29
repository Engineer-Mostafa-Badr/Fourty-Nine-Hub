import 'dart:math';

import 'package:flutter/material.dart';

class LabelColorsMap {
  static Map<String, Color> labelColors = {
    'Colors.red': Colors.red,
    'Colors.blueGrey': Colors.blueGrey,
    'Colors.pink': Colors.pink,
    'Colors.purple': Colors.purple,
    'Colors.deepPurple': Colors.deepPurple,
    'Colors.indigo': Colors.indigo,
    'Colors.blue': Colors.blue,
    'Colors.lightBlue': Colors.lightBlue,
    'Colors.cyan': Colors.cyan,
    'Colors.teal': Colors.teal,
    'Colors.green': Colors.green,
    'Colors.lightGreen': Colors.lightGreen,
    'Colors.lime': Colors.lime,
    'Colors.yellow': Colors.yellow,
    'Colors.amber': Colors.amber,
    'Colors.orange': Colors.orange,
    'Colors.deepOrange': Colors.deepOrange,
    'Colors.brown': Colors.brown,
    'Colors.grey': Colors.grey,
    'Colors.blueAccent': Colors.blueAccent,
    'Colors.redAccent': Colors.redAccent,
    'Colors.greenAccent': Colors.greenAccent,
    'Colors.purpleAccent': Colors.purpleAccent,
    'Colors.orangeAccent': Colors.orangeAccent,
    'Colors.cyanAccent': Colors.cyanAccent,
    'Colors.tealAccent': Colors.tealAccent,
    'Colors.amberAccent': Colors.amberAccent,
    'Colors.deepPurpleAccent': Colors.deepPurpleAccent,
    'Colors.lightGreenAccent': const Color.fromRGBO(178, 255, 89, 1),
    'Colors.limeAccent': Colors.limeAccent,
    'Colors.pinkAccent': Colors.pinkAccent,
    'Colors.indigoAccent': Colors.indigoAccent,
  };

  static Color? getColor(String key) {
    return labelColors[key];
  }

  static String getRandomColor() {
    Random random = Random();
    return (labelColors.keys.toList()..shuffle(random)).first;
  }
}
