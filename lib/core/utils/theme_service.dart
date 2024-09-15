import 'package:shared_preferences/shared_preferences.dart';

class ThemeServices {
  static Future<void> savethemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeMode', isDarkMode);
  }

  static bool getThemeMode() {
    bool isDarkMode = false;
    SharedPreferences.getInstance().then((value) {
      isDarkMode = value.getBool('themeMode') ?? false;
    });
    return isDarkMode;
  }
}
