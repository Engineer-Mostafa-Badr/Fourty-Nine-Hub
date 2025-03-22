import 'dart:convert';
import 'dart:developer';

import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CacheManager {
  static late SharedPreferences prefs;
  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

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
      return prefs.getBool(isFloatingNavigatorEnabled) ?? true;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> getChoiceRuler() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isChoiceRuler ${prefs.getBool(isChoiceRuler)}');
      return prefs.getBool(isChoiceRuler) ?? true;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> getEnabledChoiceRuler() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('isChoiceRulerEnabled ${prefs.getBool(isChoiceRulerEnabled)}');
      return prefs.getBool(isChoiceRulerEnabled) ?? true;
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
}
