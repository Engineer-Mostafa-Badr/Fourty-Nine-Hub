import 'dart:ui';

import 'package:flutter/material.dart';

final List<Map<String, dynamic>> advancedFilters = [
  {
    'name': 'No Filter',
    'colorFilter': ColorFilter.matrix([
      1.0, 0.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Advanced Sepia',
    'colorFilter': const ColorFilter.matrix([
      0.393, 0.769, 0.189, 0.0, 0.0,
      0.349, 0.686, 0.168, 0.0, 0.0,
      0.272, 0.534, 0.131, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'High Contrast',
    'colorFilter': const ColorFilter.matrix([
      1.5, 0.0, 0.0, 0.0, -128.0,
      0.0, 1.5, 0.0, 0.0, -128.0,
      0.0, 0.0, 1.5, 0.0, -128.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Invert Colors',
    'colorFilter': const ColorFilter.matrix([
      -1.0, 0.0, 0.0, 0.0, 255.0,
      0.0, -1.0, 0.0, 0.0, 255.0,
      0.0, 0.0, -1.0, 0.0, 255.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Brightness Adjust',
    'colorFilter': const ColorFilter.matrix([
      1.0, 0.0, 0.0, 0.0, 50.0,
      0.0, 1.0, 0.0, 0.0, 50.0,
      0.0, 0.0, 1.0, 0.0, 50.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Saturation Boost',
    'colorFilter': const ColorFilter.matrix([
      1.2, 0.0, 0.0, 0.0, 0.0,
      0.0, 1.2, 0.0, 0.0, 0.0,
      0.0, 0.0, 1.2, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Black and White',
    'colorFilter': const ColorFilter.matrix([
      0.2126, 0.7152, 0.0722, 0.0, 0.0,
      0.2126, 0.7152, 0.0722, 0.0, 0.0,
      0.2126, 0.7152, 0.0722, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Cool Blue',
    'colorFilter': const ColorFilter.matrix([
      0.9, 0.0, 0.0, 0.0, 0.0,
      0.0, 0.9, 0.0, 0.0, 0.0,
      0.0, 0.0, 1.2, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Warm Yellow',
    'colorFilter': const ColorFilter.matrix([
      1.2, 0.0, 0.0, 0.0, 0.0,
      0.0, 1.1, 0.0, 0.0, 0.0,
      0.0, 0.0, 0.9, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Solarize',
    'colorFilter': const ColorFilter.matrix([
      -1.0, 0.0, 0.0, 0.0, 255.0,
      0.0, -1.0, 0.0, 0.0, 255.0,
      0.0, 0.0, -1.0, 0.0, 255.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Vivid',
    'colorFilter': const ColorFilter.matrix([
      1.3, 0.0, 0.0, 0.0, 0.0,
      0.0, 1.3, 0.0, 0.0, 0.0,
      0.0, 0.0, 1.3, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Sharpen',
    'colorFilter': const ColorFilter.matrix([
      1.5, 0.0, 0.0, 0.0, -0.5,
      0.0, 1.5, 0.0, 0.0, -0.5,
      0.0, 0.0, 1.5, 0.0, -0.5,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Edge Detection',
    'colorFilter': const ColorFilter.matrix([
      1.0, -1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, -1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, -1.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
  {
    'name': 'Soft Light',
    'colorFilter': ColorFilter.mode(
      Colors.black.withOpacity(0.1),
      BlendMode.softLight,
    ),
  },
  {
    'name': 'Overlay',
    'colorFilter': ColorFilter.mode(
      Colors.grey.withOpacity(0.7),
      BlendMode.overlay,
    ),
  },
  {
    'name': 'Emboss',
    'colorFilter': const ColorFilter.matrix([
      2.0, -1.0, 0.0, 0.0, 0.0,
      -1.0, 2.0, -1.0, 0.0, 0.0,
      0.0, -1.0, 2.0, 0.0, 0.0,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]),
  },
];
