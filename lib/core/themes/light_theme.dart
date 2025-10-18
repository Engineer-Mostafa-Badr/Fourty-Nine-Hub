import 'package:flutter/material.dart';

import '../../res/style/app_colors.dart';
import '../../res/style/styles.dart';

ThemeData get lightTheme => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.PRIMARY_COLOR),
      primaryColor: AppColors.PRIMARY_COLOR,
      scaffoldBackgroundColor: AppColors.AUTH_CONTAINER_COLOR,
      //scaffoldBackgroundColor: Colors.grey[200],
      // colorScheme: ColorScheme.fromSeed(
      //   background: Colors.white,
      //   seedColor: const Color(0xff0b1035),
      // ),
      useMaterial3: true,
      // ضيف السطور دي هنا 👇
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   systemNavigationBarColor:
        //       AppColors.AUTH_CONTAINER_COLOR, // لون أبيض للـ Light Mode
        //   systemNavigationBarIconBrightness: Brightness.dark, // أيقونات سوداء
        // ),
      ),

      switchTheme: const SwitchThemeData(
        trackColor: WidgetStatePropertyAll<Color>(AppColors.SECONDARY_COLOR),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.PRIMARY_COLOR;
          }
          return AppColors.BG_GRAY_COLOR;
        }),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
        dialHandColor: AppColors.PRIMARY_COLOR,
        dialBackgroundColor: AppColors.PRIMARY_COLOR.withValues(alpha: .15),
        dayPeriodBorderSide: const BorderSide(color: AppColors.PRIMARY_COLOR),
        dayPeriodColor: AppColors.PRIMARY_COLOR.withValues(alpha: .15),
        dayPeriodTextColor: AppColors.PRIMARY_COLOR,
        hourMinuteTextColor: AppColors.PRIMARY_COLOR,
        hourMinuteColor: AppColors.PRIMARY_COLOR.withValues(alpha: .15),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => AppColors.PRIMARY_COLOR,
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        headerBackgroundColor: AppColors.PRIMARY_COLOR,
        headerForegroundColor: AppColors.AUTH_CONTAINER_COLOR,
        backgroundColor: AppColors.AUTH_CONTAINER_COLOR,
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.AUTH_CONTAINER_COLOR; // Text color when selected
          }
          return AppColors.PRIMARY_COLOR; // Default text color
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.PRIMARY_COLOR; // Background color when selected
          }
          return Colors.transparent; // Default background
        }),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => AppColors.PRIMARY_COLOR,
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => AppColors.PRIMARY_COLOR,
          ),
        ),
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
      bottomAppBarTheme: BottomAppBarThemeData(),
      canvasColor: Colors.black38,
      bannerTheme: const MaterialBannerThemeData(),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent),
      cardColor: Colors.white,
      dialogTheme: DialogThemeData(),
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
      tabBarTheme: TabBarThemeData(
        indicatorColor: AppColors.PRIMARY_COLOR,
      ),
    );
