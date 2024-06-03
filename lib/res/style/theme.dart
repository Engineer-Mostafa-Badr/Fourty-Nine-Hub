import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

final lightTheme = ThemeData(
    fontFamily: 'WorkSans',
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: TextTheme(
      bodySmall: _normalText(14.0, false),
      // bodyText2: _normalText(16.0, false),
      // headline1: _boldText(16.0, false),
      // headline2: _boldText(18.0, false),
      // headline3: _boldText(21.0, false),
      // headline4: _boldText(24.0, false),
      // headline5: _boldText(28.0, false),
      // headline6: _boldText(32.0, false),
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.light(primary: AppColors.PRIMARY_COLOR),
    radioTheme: RadioThemeData(
      overlayColor: MaterialStateColor.resolveWith(
        (states) => AppColors.GREY_NORMAL_COLOR,
      ),
      fillColor: MaterialStateColor.resolveWith(
        (states) => AppColors.PRIMARY_COLOR,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return AppColors.PRIMARY_COLOR;
          } else
            return AppColors.PRIMARY_COLOR;
        }),
        side: const BorderSide(color: AppColors.GREY_NORMAL_COLOR, width: 2.0),
        checkColor: MaterialStateProperty.all(AppColors.PRIMARY_COLOR_DARK),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))));

final darkTheme = ThemeData(
    fontFamily: 'WorkSans',
    dividerColor: Colors.white,
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: TextTheme(
      bodySmall: _normalText(14.0, true),
      // bodyText2: _normalText(16.0, true),
      // headline1: _boldText(16.0, true),
      // headline2: _boldText(18.0, true),
      // headline3: _boldText(21.0, true),
      // headline4: _boldText(24.0, true),
      // headline5: _boldText(28.0, true),
      // headline6: _boldText(32.0, true),
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.light(primary: AppColors.PRIMARY_COLOR),
    radioTheme: RadioThemeData(
      overlayColor: MaterialStateColor.resolveWith(
        (states) => AppColors.GREY_NORMAL_COLOR,
      ),
      fillColor: MaterialStateColor.resolveWith(
        (states) => AppColors.PRIMARY_COLOR,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return AppColors.PRIMARY_COLOR;
          } else
            return AppColors.PRIMARY_COLOR;
        }),
        checkColor: MaterialStateProperty.all(AppColors.PRIMARY_COLOR_DARK),
        side: const BorderSide(color: AppColors.GREY_NORMAL_COLOR, width: 2.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))));

TextStyle _boldText(double size, bool isDark) {
  return TextStyle(
    color: isDark ? Colors.white : Colors.black,
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.bold,
    fontSize: size,
  );
}

TextStyle _normalText(double size, bool isDark) {
  return TextStyle(
    color: isDark ? Colors.white : Colors.black,
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.w400,
    fontSize: size,
  );
}

const textHeight = 1.0;
const navbarHeight = 85.0;
const sliverAppbarExtensionHeight = 200.0;
