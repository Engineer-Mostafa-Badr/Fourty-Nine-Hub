import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const themeDarkKey = 'darkTheme';
  // static const themeLightKey = 'lightTheme';

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Delete all tokens

  static Future<bool> deleteAllTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.clear();
      log("all tokens deleted ref token :${prefs.getString(_refreshTokenKey)} , access token : ${prefs.getString(_accessTokenKey)}");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isDarkMode(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return await prefs.setBool(themeDarkKey, value);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(themeDarkKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  //set int
  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  //get int
  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
