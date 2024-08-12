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
    drawerTheme: const DrawerThemeData(),
    actionIconTheme: const ActionIconThemeData(),
    bottomAppBarTheme: const BottomAppBarTheme(),
    canvasColor: Colors.black38,
    bannerTheme: const MaterialBannerThemeData(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
    cardColor: Colors.white,
    dialogTheme: const DialogTheme(),
    bottomSheetTheme: const BottomSheetThemeData(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    iconButtonTheme: const IconButtonThemeData(),
    elevatedButtonTheme:  ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue,textStyle: TextStyle(color: Colors.white,fontSize: 20)),

    ),
    textButtonTheme: const TextButtonThemeData(),
    listTileTheme: const ListTileThemeData(),
    dividerTheme: const DividerThemeData(),
    tabBarTheme: const TabBarTheme(),
  );
}
