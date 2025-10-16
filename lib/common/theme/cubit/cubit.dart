import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // أضف الـ import ده
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(LightThemeModeStates());

  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDarkTheme = false;

  Future<void> getMode() async {
    isDarkTheme = await CacheManager.getMode();
    emit(isDarkTheme ? DarkThemeModeStates() : LightThemeModeStates());
  }

  Future<void> lightThemeMode() async {
    isDarkTheme = false;
    await CacheManager.isDarkMode(isDarkTheme);

    // تحديث System Navigation Bar فوراً للـ Light Mode
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // أبيض
        systemNavigationBarIconBrightness: Brightness.dark, // أيقونات سوداء
      ),
    );

    emit(LightThemeModeStates());
    print(isDarkTheme);
    print('isDark saved to ${await CacheManager.getMode()}');
  }

  Future<void> darkThemeMode() async {
    isDarkTheme = true;
    await CacheManager.isDarkMode(isDarkTheme);

    // تحديث System Navigation Bar فوراً للـ Dark Mode
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // أسود
        systemNavigationBarIconBrightness: Brightness.light, // أيقونات بيضاء
      ),
    );

    emit(DarkThemeModeStates());
    print(isDarkTheme);
    print('isDark saved to ${await CacheManager.getMode()}');
  }
}
