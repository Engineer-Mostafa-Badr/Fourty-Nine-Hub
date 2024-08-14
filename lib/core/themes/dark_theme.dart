import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.DARK_BLUE_COLOR,
    scaffoldBackgroundColor: AppColors.SPLASH_BLACK_COLOR,
    appBarTheme: const AppBarTheme(
      color: AppColors.DARK_BLUE_COLOR,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.LIGHT_GRAY_COLOR),
      bodySmall: TextStyle(color: AppColors.LIGHT_GRAY_COLOR),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.LIGHT_COLOR,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.PRIMARY_COLOR_DARK,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.UNSELECTED_DARK_GRAY_COLOR,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: AppColors.UNSELECTED_GRAY_COLOR,
        ),
      ),
    ),
    dividerColor: AppColors.GREY_DARK_COLOR,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.DARK_BLUE_COLOR,
      secondary: AppColors.SECONDARY_COLOR,
    ),
  );
}
