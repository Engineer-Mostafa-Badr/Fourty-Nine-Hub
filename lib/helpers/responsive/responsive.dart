import 'package:flutter/material.dart';
import '../../routes/pages.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get _screenWidth => MediaQuery.of(context).size.width;
  double get _screenHeight => MediaQuery.of(context).size.height;

  // Base dimensions (design reference, e.g., Figma uses 360x640)
  static const double _baseWidth = 375;
  static const double _baseHeight = 701;

  // Responsive width
  double wp(double pixels) => (pixels / _baseWidth) * _screenWidth;

  // Responsive height
  double hp(double pixels) => (pixels / _baseHeight) * _screenHeight;

  // Responsive radius (scaled to width)
  double r(double pixels) => wp(pixels);

  // Responsive font size (optional)
  double sp(double pixels) => wp(pixels);
}

extension ResponsiveExtension on num {
  double get _width => Responsive(AppPages.router.configuration.navigatorKey.currentContext!).wp(toDouble());
  double get _height => Responsive(AppPages.router.configuration.navigatorKey.currentContext!).hp(toDouble());
  double get _radius => Responsive(AppPages.router.configuration.navigatorKey.currentContext!).r(toDouble());
  double get _textSize => Responsive(AppPages.router.configuration.navigatorKey.currentContext!).r(toDouble());

  // Usage: 30.width, 50.height, 10.radius
  SizedBox get width => SizedBox(width: _width);
  SizedBox get height => SizedBox(height: _height);
  double get ws => _width;  // For direct double (e.g., Container(width: 30.ws))
  double get hs => _height;
  double get ts => _textSize;
  Radius get radius => Radius.circular(_radius);
  BorderRadius get borderRadius => BorderRadius.circular(_radius);
}