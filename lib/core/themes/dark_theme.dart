import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/style/app_colors.dart';
import '../../res/style/styles.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.AUTH_CONTAINER_COLOR,
    scaffoldBackgroundColor: AppColors.QUANTITY_COLOR,
    appBarTheme: const AppBarTheme(
      color: AppColors.QUANTITY_COLOR,
      iconTheme: IconThemeData(
        color: AppColors.AUTH_CONTAINER_COLOR,
      ),
    ),
    // textSelectionTheme: const TextSelectionThemeData(
    //   selectionColor: AppColors.PRIMARY_COLOR,
    //   cursorColor: AppColors.PRIMARY_COLOR,
    //   selectionHandleColor: AppColors.PRIMARY_COLOR,
    // ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.AUTH_CONTAINER_COLOR),
      bodySmall: TextStyle(color: AppColors.AUTH_CONTAINER_COLOR),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.AUTH_CONTAINER_COLOR,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.AUTH_CONTAINER_COLOR,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.GREY_DARK_COLOR,
      hintStyle: Styles.headerText(fontSize: 25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: AppColors.AUTH_CONTAINER_COLOR,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
      ),
    ),
    dividerColor: AppColors.GREY_DARK_COLOR,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.AUTH_CONTAINER_COLOR,
      secondary: AppColors.AUTH_CONTAINER_COLOR,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.QUANTITY_COLOR,
    ),
    actionIconTheme: const ActionIconThemeData(),
    bottomAppBarTheme: const BottomAppBarTheme(),
    canvasColor: Colors.black38,
    bannerTheme: const MaterialBannerThemeData(),
    switchTheme: const SwitchThemeData(
      trackColor: WidgetStatePropertyAll<Color>(Colors.grey),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
    cardColor: Colors.white,
    dialogTheme: const DialogTheme(),
    bottomSheetTheme: const BottomSheetThemeData(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    iconButtonTheme: const IconButtonThemeData(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          textStyle: TextStyle(color: Colors.white, fontSize: 20.sp)),
    ),
    textButtonTheme: const TextButtonThemeData(),
    listTileTheme: const ListTileThemeData(),
    dividerTheme: const DividerThemeData(),
    tabBarTheme: const TabBarTheme(),
  );
}
