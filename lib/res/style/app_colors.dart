import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

abstract class AppColors {
  static const PRIMARY_COLOR = Color(0xFF0B1135);
  static const blueColor = Colors.blue;
  static const black = Color(0xFF000000);
  static const buttonDialog = Color(0xFF0A0A2A);
  static const Color colorNavy = Color(0xFF0A0A2A); // لون داكن للأزرار
  static const Color colorRed = Color(0xFFFF4C4C);  // لون أحمر للأزرار
  static const Color colorGreyLight = Color(0xFFF5F5F5);

  static const DARK_BLUE_COLOR = Color.fromARGB(255, 22, 23, 24);
  static const UNSELECTED_GRAY_COLOR = Color(0xFFD2D2D2);
  static const UNSELECTED_DARK_GRAY_COLOR = Color(0xFF2D2D2D);
  static const SPLASH_BLACK_COLOR = Color(0xFF222222);

  static const MESSAGE_COLOR = whatsAppGreenColor;
  // static const MESSAGE_COLOR = Color(0xffcfd1e3);
  static const whiteColor = Colors.white;

  static const DARK_GRAY_COLOR = Color(0xFF909090);
  static const grey300 = Color(0xFFB3B3B3);
  static const LIGHT_GRAY_COLOR = Color(0xFFE0E0E0);
  static const BG_GRAY_COLOR = Color(0xFFD9D9D9);
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
  static const SECONDARY_COLOR_DARK2 = Color(0xFFF33D49);
  static const Floating_Button_COLOR_DARK = Color(0xFFCACFF4);
  static const Scaffold_Color_DARK = Color(0xFF0D0D0D);
  static const fill_Color_DARK = Color(0xFF171717);
  static const red_Color_DARK = Color(0xFFF45560);
  static const Find_fill_DARK = Color(0xFF262626);
  static const Facebook_Red_DARK = Color(0xFFFF4622);
  static const Facebook_Fill_Red_DARK = Color(0xFFFFEEEB);
  static const c0B1035 = Color(0xFF0B1035);
  static const c46484B = Color(0xFF46484B);
  static const cF5F5F5 = Color(0xFFF5F5F5);
  static const cE8E8E8 = Color(0xFFE8E8E8);
  static const c6E6E70 = Color(0xFF6E6E70);
  static const c19D176 = Color(0xFF19D176);
  static const c3897F0 = Color(0xFF3897F0);
  static const c96979B = Color(0xFF96979B);
  static const cEEEEEEE = Color(0xFFEEEEEEE);
  static const c161F68 = Color(0xFF161F68);
  static const c1B2781 = Color(0xFF1B2781);
  static const c1E2B8E = Color(0xFF1E2B8E);
  static const c1F2D95 = Color(0xFF1F2D95);
  static const cD9D9D9 = Color(0xFFD9D9D9);
  static const c6C6C6C = Color(0xFF6C6C6C);
  static const c717171 = Color(0xFF717171);
  static const cE0E0E0 = Color(0xFFE0E0E0);

  static const cF33D49 = Color(0xFFF33D49);
  static const cC0303A = Color(0xFFC0303A);
  static const cA72A32 = Color(0xFFA72A32);
  static const c9A272E = Color(0xFF9A272E);
  static const c93252C = Color(0xFF93252C);
  static const c90242B = Color(0xFF90242B);
  static const cF7F7F7 = Color(0xFFF7F7F7);
  static const cF3F3F3 = Color(0xFFF3F3F3);
  static const c5A5A5A = Color(0xFF5A5A5A);

  // static const SECONDARY_COLOR = Color(0xffff3308);

  static const BARRIER_COLOR = Color(0x800E1E4E);
  static const ACCENT_COLOR = Color.fromARGB(255, 244, 174, 62);

  // static const BACKGROUND_COLOR = Color.fromARGB(255, 238, 238, 238);
  static const BACKGROUND_COLOR = Color(0xFFFFFFFF);
  static const GREY_LIGHT_COLOR = Color(0xFFF3F3F3);
  static const GREY_NORMAL_COLOR = Color(0xFFB9B9B9);
  static const GREYCARD = Color(0xFFEDEBEB);
  static const GREYFIELD = Color(0xFFF5F5F5);
  static const GREYTEXT = Color(0xFF949494);
  static const GREYICON = Color(0xFF414141);
  static const GREYBG2 = Color(0xffDBD1D1);
  static const GREYBG = Color(0xFFD9D9D9);
  static const GREY_DARK_COLOR = Color(0xFF707070);
  static const GREY_BORDER_COLOR = Color(0xFFDEDEDE);
  static const WHATS_APP_COLOR = Color(0xFF55CD6C);
  static const RIGHT_SGIN = Color(0xFF7BBA69);
  static const Arrow_Icon_color = Color(0xFF374957);
  static const AUTH_CONTAINER_COLOR = Colors.white;
  static const CHECK_MARK_COLOR = Color(0xFF55CD6C);
  static const LIGHT_BLUE = Color.fromRGBO(60, 153, 225, 1);
  static const grey = Colors.grey;
  static const LightWHATS_APP_COLOR = Color(0xFF8CF59F);
  // static const whatsAppGreenColor = Color(0xFFdcf8c6);
  static const whatsAppGreenColor = Color(0xFFD5F0F6);

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

  static var textSecondary;
  static Color getSecondryColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.SECONDARY_COLOR_DARK
        : AppColors.SECONDARY_COLOR;
  }
  static Color getTextColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.whiteColor
        : AppColors.black;
  }
  static Color getPrimaryTextColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.PRIMARY_COLOR
        : AppColors.whiteColor;
  }
  static Color getReversedTextColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.black
        : AppColors.whiteColor;
  }
  static Color getRedColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.red_Color_DARK
        : AppColors.SECONDARY_COLOR;
  }
  static Color getButtonPrimaryColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.Floating_Button_COLOR_DARK
        : AppColors.PRIMARY_COLOR;
  }
  static Color getButtonPrimaryWhiteColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.whiteColor
        : AppColors.PRIMARY_COLOR;
  }
  static Color getFillColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.fill_Color_DARK
        : AppColors.LIGHT_GRAY_COLOR;
  }
  static Color getFindFillColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.Find_fill_DARK
        : AppColors.LIGHT_GRAY_COLOR;
  }
  static Color getFacebookFillRedColor(BuildContext context) {
    return context.isDarkMode
        ? AppColors.Find_fill_DARK
        :AppColors.Facebook_Fill_Red_DARK ;
  }
  
}