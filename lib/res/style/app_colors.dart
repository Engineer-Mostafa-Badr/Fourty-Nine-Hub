import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

abstract class AppColors {
  static const PRIMARY_COLOR = Color(0xFF0B1035);
  static const blueColor = Colors.blue;

  static const DARK_BLUE_COLOR = Color.fromARGB(255, 22, 23, 24);
  static const UNSELECTED_GRAY_COLOR = Color(0xFFD2D2D2);
  static const UNSELECTED_DARK_GRAY_COLOR = Color(0xFF2D2D2D);
  static const SPLASH_BLACK_COLOR = Color(0xFF222222);

  static const MESSAGE_COLOR = Color(0xffcfd1e3);
  static const whiteColor = Colors.white;

  static const DARK_GRAY_COLOR = Color(0xFF909090);
  static const LIGHT_GRAY_COLOR = Color(0xFFE0E0E0);
  static const LIGHT_GRAY_COLOR2 = Color(0xFFA5A3A3);
  static const TXTFIELD_GRAY_COLOR2 = Color(0xFFEEEEEE);
  static const DIVIDER_GRAY_COLOR2 = Color(0xFFAFAFAF);

  static const DIVIDER_GRAY_COLOR = Color(0xFFEBEBF0);
  static const GRAY_LIGHT_COLOR3 = Color(0xFFF0F0F0);
  static const LIGHT_COLOR = Color.fromARGB(255, 255, 255, 255);
  static const YELLOW_COLOR = Color(0xFFFFE76B);

  static const QUANTITY_COLOR = Color(0xFF35383F);
  static const PRIMARY_COLOR_LIGHT = Color.fromARGB(255, 7, 5, 5);
  static const PRIMARY_COLOR_DARK = Color(0xFFED1C24);
  static const SECONDARY_COLOR = Color(0xFFED1C24);
  static const SECONDARY_COLOR_DARK = Color(0xFFec5749);
  // static const SECONDARY_COLOR = Color(0xffff3308);

  static const BARRIER_COLOR = Color(0x800E1E4E);
  static const ACCENT_COLOR = Color.fromARGB(255, 244, 174, 62);

  // static const BACKGROUND_COLOR = Color.fromARGB(255, 238, 238, 238);
  static const BACKGROUND_COLOR = Color(0xFFFFFFFF);
  static const GREY_LIGHT_COLOR = Color(0xFFF3F3F3);
  static const GREY_NORMAL_COLOR = Color(0xFFB9B9B9);
  static const GREYCARD = Color(0xFFEDEBEB);
  static const GREYTEXT = Color(0xFF949494);
  static const GREYBG = Color(0xFFD9D9D9);
  static const GREY_DARK_COLOR = Color(0xFF707070);
  static const GREY_BORDER_COLOR = Color(0xFFDEDEDE);
  static const WHATS_APP_COLOR = Color(0xFF55CD6C);
  static const Arrow_Icon_color = Color(0xff374957);
  static const AUTH_CONTAINER_COLOR = Colors.white;
  static const CHECK_MARK_COLOR = Color(0xFF55CD6C);
  static const LIGHT_BLUE = Color.fromRGBO(60, 153, 225, 1);

  static const BLACK_GRAY_GRADIENT = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFa9a9a9),
      Color(0xfff0f0f0),
    ],
  );

  static const LIGHT_GRADIENT = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF3F3F3),
      Color(0xFFFFEBEB),
    ],
  );

  static const DRAWER_GRADIENT_COLOR = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFDC0E3A),
      Color(0xFF6E071D),
    ],
    stops: [0.0, 0.65],
  );

  static const SHADOW = [
    BoxShadow(
      color: Color(0x99000000),
      spreadRadius: 0.03,
      blurRadius: 6,
    ),
  ];

  static const SHADOW_LIGHT = [
    BoxShadow(
      color: Color(0x44000000),
      spreadRadius: 0.03,
      blurRadius: 6,
    ),
  ];
  static Color getSecondryColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.SECONDARY_COLOR_DARK
        : AppColors.SECONDARY_COLOR;
  }
}
