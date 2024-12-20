import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';
import '../../res/style/styles.dart';

ThemeData get lightTheme => ThemeData(
      primaryColor: AppColors.PRIMARY_COLOR,
      scaffoldBackgroundColor: AppColors.AUTH_CONTAINER_COLOR,
      //scaffoldBackgroundColor: Colors.grey[200],
      // colorScheme: ColorScheme.fromSeed(
      //   background: Colors.white,
      //   seedColor: const Color(0xff0b1035),
      // ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: AppColors.AUTH_CONTAINER_COLOR,
      ),
      switchTheme: const SwitchThemeData(
        trackColor: WidgetStatePropertyAll<Color>(AppColors.SECONDARY_COLOR),
      ),
      textTheme: const TextTheme(
        displayMedium: TextStyle(color: AppColors.QUANTITY_COLOR),
        // displaySmall: TextStyle(color: AppColors.DARK_GRAY_COLOR),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.QUANTITY_COLOR,
      ),
      // textSelectionTheme: const TextSelectionThemeData(
      //   selectionColor: AppColors.PRIMARY_COLOR,
      //   cursorColor: AppColors.PRIMARY_COLOR,
      //   selectionHandleColor: AppColors.PRIMARY_COLOR,
      // ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.QUANTITY_COLOR,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.GREY_LIGHT_COLOR,
        hintStyle: Styles.headerText(
            fontSize: 25,
            decoration: TextDecoration.none,
            decorationThickness: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.DIVIDER_GRAY_COLOR2,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      dividerColor: AppColors.DIVIDER_GRAY_COLOR,
      drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.AUTH_CONTAINER_COLOR),
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
      ),
      textButtonTheme: const TextButtonThemeData(),
      listTileTheme: const ListTileThemeData(),
      dividerTheme: const DividerThemeData(),
      tabBarTheme: const TabBarTheme(),
    );
