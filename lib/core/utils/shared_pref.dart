import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CacheManager {
  static late SharedPreferences prefs;
  static final StreamController<bool> _activationStreamController = StreamController<bool>.broadcast();
  
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }
  
  // Stream to listen for activation changes
  static Stream<bool> get activationStream => _activationStreamController.stream;

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const themeDarkKey = 'darkTheme';
  static const activeCustomPage = 'activeCustomPage';
  static const selectedCategoryView = 'selectedCategoryView';
  static const RIDESOCKETPARTMODEL = 'RIDESOCKETPARTMODEL';
  static const isFloatingNavigator = 'isFloatingNavigator';
  static const isFloatingNavigatorEnabled = 'isFloatingNavigatorEnabled';

  static const isChoiceRuler = 'isChoiceRuler';
  static const isChoiceRulerEnabled = 'isChoiceRulerEnabled';
  static const showOnboarding = 'showOnboarding';
  static const forgotPasswordTimerKey = 'forgotPasswordTimer';
  static const tripOfferTimersKey = 'tripOfferTimers';

  // static const themeLightKey = 'lightTheme';

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  // Save active custom page
  static Future<void> updateActive(bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(activeCustomPage, active);
    // Emit the change through the stream
    _activationStreamController.add(active);
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

  // Retrieve access token
  static Future<bool?> getActivation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(activeCustomPage);
  }

  // Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Clear only tokens (without clearing all prefs)
  static Future<bool> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      // Also clear the login status
      await prefs.setBool("ISLOGIN", false);
      log("Tokens cleared - ref token :${prefs.getString(_refreshTokenKey)} , access token : ${prefs.getString(_accessTokenKey)}");
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout while keeping important settings (onboarding, language, dark mode)
  static Future<bool> logoutKeepingSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save current settings before clearing
      bool? isDarkMode = prefs.getBool(themeDarkKey);
      bool? hasSeenOnboarding = prefs.getBool(showOnboarding);
      
      // Clear tokens and login status
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.setBool("ISLOGIN", false);
      
      // Restore important settings
      if (isDarkMode != null) {
        await prefs.setBool(themeDarkKey, isDarkMode);
      }
      if (hasSeenOnboarding != null) {
        await prefs.setBool(showOnboarding, hasSeenOnboarding);
      }
      
      log("Logout completed keeping settings - ref token :${prefs.getString(_refreshTokenKey)} , access token : ${prefs.getString(_accessTokenKey)}");
      return true;
    } catch (e) {
      log("Error in logoutKeepingSettings: $e");
      return false;
    }
  }

  // Delete all tokens

  static Future<bool> deleteAllTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove('RefreshToken');
      // await prefs.clear();
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

  static Future<bool> isFloatingNavigatorOpen(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(isFloatingNavigator, value);
    } catch (e) {
      return false;
    }
  }
  static Future<bool> isChoiceRulerOpen(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isChoiceRulerOpen $value');

      return await prefs.setBool(isChoiceRuler, value);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isChoiceRulerEnabledOpen(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isChoiceRulerEnabledOpen $value');

      return await prefs.setBool(isChoiceRulerEnabled, value);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isShowOnboarding(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isShowOnboarding $value');

      return await prefs.setBool(showOnboarding, value);
    } catch (e) {
      return false;
    }
  }
  static Future<bool> isFloatingNavigatorEnabledOpen(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isFloatingNavigatorEnabledOpen $value');

      return await prefs.setBool(isFloatingNavigatorEnabled, value);
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
  static Future<bool> getFloatingNavigator() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isFloatingNavigator ${prefs.getBool(isFloatingNavigator)}');
      return prefs.getBool(isFloatingNavigator) ?? false;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> getFloatingNavigatorEnable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isFloatingNavigatorEnabled ${prefs.getBool(isFloatingNavigatorEnabled)}');
      return prefs.getBool(isFloatingNavigatorEnabled) ?? false;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> getChoiceRuler() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isChoiceRuler ${prefs.getBool(isChoiceRuler)}');
      return prefs.getBool(isChoiceRuler) ?? false;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> getEnabledChoiceRuler() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isChoiceRulerEnabled ${prefs.getBool(isChoiceRulerEnabled)}');
      return prefs.getBool(isChoiceRulerEnabled) ?? false;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> getShowOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isShowOnboarding ${prefs.getBool(showOnboarding)}');
      return prefs.getBool(showOnboarding) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Save forgot password timer
  static Future<bool> saveForgotPasswordTimer(DateTime timerEnd) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(forgotPasswordTimerKey, timerEnd.toIso8601String());
    } catch (e) {
      return false;
    }
  }

  // Get forgot password timer
  static Future<DateTime?> getForgotPasswordTimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timerString = prefs.getString(forgotPasswordTimerKey);
      if (timerString != null) {
        return DateTime.parse(timerString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Clear forgot password timer
  static Future<bool> clearForgotPasswordTimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(forgotPasswordTimerKey);
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
  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  static Future<PartsSocketModel?> getSocketPartModel() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(RIDESOCKETPARTMODEL);
    log(data.toString(), name: "lsdkjfskdjfdjdjdjd");
    if (data != null) {
      Map<String, dynamic> json = jsonDecode(data);
      PartsSocketModel model = PartsSocketModel.fromJson(json);
      log(json.toString(), name: "lskdfjlskjdflskjdf34lskdjf");
      return model;
    }
    return null;
  }

  static Future<void> saveSocketPartModel(PartsSocketModel model) async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(RIDESOCKETPARTMODEL);
    if (data != null) {
      try {
        Map<String, dynamic> json = jsonDecode(data);
        PartsSocketModel finalModel = PartsSocketModel.fromJson(json);
        finalModel = model.copyWith(
            basicInfo: model.basicInfo,
            carLicence: model.carLicence,
            dragAnalysisPart: model.dragAnalysisPart,
            driverLicence: model.driverLicence,
            moreInfo: model.moreInfo);
        String jsonEncod = jsonEncode(finalModel.toJson());
        log(jsonEncod, name: "jsonEncodjsonEncod");
        prefs.setString(RIDESOCKETPARTMODEL, jsonEncod);
      } catch (error) {
        log(error.toString());
      }
    } else {
      log(model.toJson().toString());
      try {
        log(model.toJson().toString());
        String json = jsonEncode(model.toJson());
        log(json.toString());
        var l = await prefs.setString(RIDESOCKETPARTMODEL, json);
        log("${l}lskdjfldskjfdd");
      } catch (error) {
        log(error.toString());
      }
    }
  }

  // Trip offer timer management
  static Future<bool> saveTripOfferTimer(String tripId, DateTime expireTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(tripOfferTimersKey);
      Map<String, dynamic> timers = {};
      
      if (data != null) {
        timers = jsonDecode(data) as Map<String, dynamic>;
      }
      
      timers[tripId] = expireTime.toIso8601String();
      return await prefs.setString(tripOfferTimersKey, jsonEncode(timers));
    } catch (e) {
      log("Error saving trip offer timer: $e");
      return false;
    }
  }

  // Get remaining time for a trip offer
  static Future<Duration?> getTripOfferRemainingTime(String tripId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(tripOfferTimersKey);
      
      if (data == null) return null;
      
      final timers = jsonDecode(data) as Map<String, dynamic>;
      if (!timers.containsKey(tripId)) return null;
      
      final expireTimeStr = timers[tripId] as String;
      final expireTime = DateTime.parse(expireTimeStr);
      final now = DateTime.now();
      
      if (now.isAfter(expireTime)) {
        // Timer has expired, remove it
        timers.remove(tripId);
        await prefs.setString(tripOfferTimersKey, jsonEncode(timers));
        return null;
      }
      
      return expireTime.difference(now);
    } catch (e) {
      log("Error getting trip offer remaining time: $e");
      return null;
    }
  }

  // Check if a trip has an active timer
  static Future<bool> hasActiveOfferTimer(String tripId) async {
    try {
      final remaining = await getTripOfferRemainingTime(tripId);
      return remaining != null && remaining.inSeconds > 0;
    } catch (e) {
      return false;
    }
  }

  // Clean up expired timers
  static Future<void> cleanupExpiredTimers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(tripOfferTimersKey);
      print("tripOfferTimersKey $data");
      if (data == null||data.isEmpty) return;
      
      final timers = jsonDecode(data) as Map<String, dynamic>;
      final now = DateTime.now();
      final expiredKeys = <String>[];
      
      timers.forEach((tripId, expireTimeStr) {
        final expireTime = DateTime.parse(expireTimeStr as String);
        if (now.isAfter(expireTime)) {
          expiredKeys.add(tripId);
        }
      });
      
      for (final key in expiredKeys) {
        timers.remove(key);
      }
      
      await prefs.setString(tripOfferTimersKey, jsonEncode(timers));
    } catch (e) {
      log("Error cleaning up expired timers: $e");
    }
  }

  // Remove a specific trip timer
  static Future<bool> removeTripOfferTimer(String tripId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(tripOfferTimersKey);
      
      if (data == null) return true;
      
      final timers = jsonDecode(data) as Map<String, dynamic>;
      timers.remove(tripId);
      
      return await prefs.setString(tripOfferTimersKey, jsonEncode(timers));
    } catch (e) {
      log("Error removing trip offer timer: $e");
      return false;
    }
  }
}
