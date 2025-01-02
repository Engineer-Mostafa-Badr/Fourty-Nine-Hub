import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_by_rider_model/check_accept_by_rider_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/check_accept_trip_from_driver_model/check_accept_trip_from_driver_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  // Future<void> init();
  Future<bool> saveUserData(String userData);
  Future<String?> getUserData();
  bool? isLogin();
  Future<void> saveRiderTripInfo(
      {required CheckAcceptTripFromDriverModel model});
  Future<void> saveDriverTripInfo({required CheckAcceptByRiderModel model});
  Future<CheckAcceptTripFromDriverModel?> getRiderTripInfo();
  Future<void> removeRiderTripInfo();
  Future<CheckAcceptByRiderModel?> getDriverTripInfo();
  Future<void> removeDriverTripInfo();
  Future<bool> saveUserIsLoggedIn(bool isLoggedIn);
  Future<bool?> getUserIsLoggedIn();
  Future<void> setLogin(bool value);

  // Future<bool> saveUserToken(String userToken);

  Future<bool> saveTripState(String value);
  Future<String> getTripState();
  Future<void> removeTripState();

  // Future<String?> getUserToken();
  Future<String?> getUserId();
  Future<bool> setUserId(String userId);

  Future<bool> saveUserRefreshToken(String userRefreshToken);
  Future<String?> getUserRefreshToken();

  Future<bool> saveUserTokenExpirationDate(String userTokenExpireDate);
  Future<String?> getUserTokenExpirationDate();

  Future<String?> getLanguageCode();
  Future<void> setLanguageCode(String languageCode);

  Future<void> clearUserData();

  Future<bool?> isNotificationEnabled();
  Future<bool?> isAdTrackingNotificationEnabled();

  Future<bool> setNotificationStatus(bool isEnabled);
  Future<bool> setAdTrackingNotification(bool isEnabled);

  Future<bool> saveAppleUserData(String userData);
  Future<String?> getAppleUserData();

  Future<bool> saveUserThemeMode(bool isDark);
  Future<bool?> getUserThemeMode();

  Future<bool> saveIsFirstLunch(bool isFirstLunch);
  Future<bool?> getIsFirstLunch();

  Future<bool> saveFavList(List<String> favList);
  Future<List<String>?> getFavList();

  String getSubCategryDriver();
  String? getDriverId();
  Future<void> setSubCategoryDriver({required String id});
  Future<void> setDriverId({required String id});
}

class CacheServiceImpl implements CacheService {
  static const _THEME_MODE = "THEME_MODE";
  static const _USERDATA = "USER_DATA";
  static const _LOCALE = 'locale';
  static const _TOKEN = "TOKEN";
  static const _ISLOGIN = "ISLOGIN";
  static const _REFRESH_TOKEN = "REFRESH_TOKEN";
  static const _TOKEN_EXPIRE_DATE = "TOKEN_EXPIRE_DATE";
  static const _IS_LOGGED_IN = "IS_LOGGED_IN";
  static const _IS_NOTIFICATION_ENABLED = "IS_NOTIFICATION_ENABLED";
  static const _IS_AD_TRACKING_NOTIFICATION_ENABLED =
      "IS_AD_TRACKING_NOTIFICATION_ENABLED";
  static const _APPLE_USER_DATA = "APPLE_USER_DATA";
  static const _IS_FIRST_LUNCH = "IS_FIRST_LUNCH";
  static const _FAV_PRODUCTS_LIST = "FAV_PRODUCTS_LIST";
  static const _SubCateogryDriver = "SubCateogryDriver";
  static const _DriverId = "DriverId";
  static const _USER_ID = "USER_ID";
  static const _TRIP_INFO_RIDER = "_TRIP_INFO_RIDER";
  static const _TRIP_INFO_DRIVER = "_TRIP_INFO_DRIVER";
  static const _TRIP_STATE = "_TRIP_STATE";
  static late SharedPreferences preferences;
  @override
  Future<bool> saveUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_USERDATA, userData);
  }

  @override
  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_USERDATA);
  }

  @override
  Future<bool> saveUserIsLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_IS_LOGGED_IN, isLoggedIn);
  }

  @override
  Future<bool?> getUserIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IS_LOGGED_IN);
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_LOCALE, languageCode);
  }

  @override
  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_LOCALE);
  }

  @override
  Future<bool> saveUserRefreshToken(String userRefreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_REFRESH_TOKEN, userRefreshToken);
  }

  @override
  Future<String?> getUserRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_REFRESH_TOKEN);
  }

  // @override
  // Future<bool> saveUserToken(String userToken) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return await prefs.setString(_TOKEN, userToken);
  // }
  //
  // @override
  // Future<String?> getUserToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_TOKEN);
  // }

  @override
  Future<bool> saveUserTokenExpirationDate(String userTokenExpireDate) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_TOKEN_EXPIRE_DATE, userTokenExpireDate);
  }

  @override
  Future<String?> getUserTokenExpirationDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_TOKEN_EXPIRE_DATE);
  }

  @override
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await saveIsFirstLunch(false);
  }

  @override
  Future<bool?> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IS_NOTIFICATION_ENABLED);
  }

  @override
  Future<bool> setNotificationStatus(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_IS_NOTIFICATION_ENABLED, isEnabled);
  }

  @override
  Future<bool?> isAdTrackingNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IS_AD_TRACKING_NOTIFICATION_ENABLED);
  }

  @override
  Future<bool> setAdTrackingNotification(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_IS_AD_TRACKING_NOTIFICATION_ENABLED, isEnabled);
  }

  @override
  Future<bool> saveAppleUserData(String appleUserData) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_APPLE_USER_DATA, appleUserData);
  }

  @override
  Future<String?> getAppleUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_APPLE_USER_DATA);
  }

  @override
  Future<bool?> getUserThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_THEME_MODE);
  }

  @override
  Future<bool> saveUserThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_THEME_MODE, isDark);
  }

  @override
  Future<bool?> getIsFirstLunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_IS_FIRST_LUNCH);
  }

  @override
  Future<bool> saveIsFirstLunch(bool isFirstLunch) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_IS_FIRST_LUNCH, isFirstLunch);
  }

  @override
  Future<List<String>?> getFavList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_FAV_PRODUCTS_LIST);
  }

  @override
  Future<bool> saveFavList(List<String> favList) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(_FAV_PRODUCTS_LIST, favList);
  }

  @override
  bool? isLogin() {
    return preferences.getBool(_ISLOGIN);
  }

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> setLogin(bool value) async {
    await preferences.setBool(_ISLOGIN, value);
  }

  @override
  String getSubCategryDriver() {
    return preferences.getString(CacheServiceImpl._SubCateogryDriver) ?? "";
  }

  @override
  Future<void> setSubCategoryDriver({required String id}) async {
    await preferences.setString(CacheServiceImpl._SubCateogryDriver, id);
  }

  @override
  String? getDriverId() {
    return preferences.getString(CacheServiceImpl._DriverId);
  }

  @override
  Future<void> setDriverId({required String id}) async {
    await preferences.setString(_DriverId, id);
  }

  @override
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_USER_ID);
  }

  @override
  Future<bool> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_USER_ID, userId);
  }

  @override
  Future<CheckAcceptByRiderModel?> getDriverTripInfo() async {
    String json = preferences.getString(CacheServiceImpl._TRIP_INFO_DRIVER)??"";
    return CheckAcceptByRiderModel.fromJson(jsonDecode(json));
      return null;
  }

  @override
  Future<CheckAcceptTripFromDriverModel?> getRiderTripInfo() async {
    String json = preferences.getString(CacheServiceImpl._TRIP_INFO_RIDER)??"";
    if (json.isNotEmpty) {
      return CheckAcceptTripFromDriverModel.fromJson(jsonDecode(json));
    } else {
      return null;
    }
      return null;
  }

  @override
  Future<void> saveDriverTripInfo(
      {required CheckAcceptByRiderModel model}) async {
    var json = jsonEncode(model.toJson());
    preferences.setString(CacheServiceImpl._TRIP_INFO_DRIVER, json);
  }

  @override
  Future<void> saveRiderTripInfo(
      {required CheckAcceptTripFromDriverModel model}) async {
    var json = jsonEncode(model.toJson());
    preferences.setString(CacheServiceImpl._TRIP_INFO_RIDER, json);
  }

  @override
  Future<void> removeDriverTripInfo() async {
    bool result = await preferences.remove(CacheServiceImpl._TRIP_INFO_DRIVER);
    log(result.toString(), name: "removeRiderTripInfo");
  }

  @override
  Future<void> removeRiderTripInfo() async {
    bool result = await preferences.remove(CacheServiceImpl._TRIP_INFO_RIDER);
    String? json = preferences.getString(CacheServiceImpl._TRIP_INFO_RIDER);
    log(result.toString(), name: "removeRiderTripInfo");
    log(json.toString(), name: "removeRiderTripInfo");
  }

  @override
  Future<String> getTripState() async {
    String state = preferences.getString(_TRIP_STATE) ?? "InLocation";
    return state;
  }

  @override
  Future<bool> saveTripState(String value) {
    return preferences.setString(_TRIP_STATE, value);
  }

  @override
  Future<void> removeTripState() async {
    preferences.remove(_TRIP_STATE);
  }
  //   @override
  // Future<bool> saveUserToken(String userToken) async {
  // final prefs = await SharedPreferences.getInstance();
  // return await prefs.setString(_TOKEN, userToken);
  // }

  // @override
  // Future<String?> getUserToken() async {
  // final prefs = await SharedPreferences.getInstance();
  // return prefs.getString(_TOKEN);
  // }
}

class CacheServiceImplV2 implements CacheService {
  static const _USERDATA = "USER_DATA";
  static const _LOCALE = 'locale';
  // static const _IS_FIRST_LAUNCH = "IS_FIRST_LAUNCH";
  static const _HAS_RUN_BEFORE = "HAS_RUN_BEFORE";
  final _completer = Completer<FlutterSecureStorage>();

  CacheServiceImplV2() {
    SharedPreferences.getInstance().then((prefs) async {
      if (prefs.getBool(_HAS_RUN_BEFORE) != true) {
        const storage = FlutterSecureStorage();
        await storage.deleteAll();
        await prefs.setBool(_HAS_RUN_BEFORE, true);
        _completer.complete(storage);
      } else {
        _completer.complete(const FlutterSecureStorage());
      }
    });
  }

  @override
  Future<bool> saveUserData(String userData) async {
    final storage = await _completer.future;
    await storage.write(key: _USERDATA, value: userData);
    return true;
  }

  @override
  Future<String?> getUserData() async {
    final storage = await _completer.future;

    return await storage.read(key: _USERDATA);
  }

  @override
  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_LOCALE);
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_LOCALE, languageCode);
  }

  // @override
  // Future<bool> getIsFirstLaunch() async {
  //   final storage = await _completer.future;

  //   final isFirstLaunch = await storage.read(key: _IS_FIRST_LAUNCH);
  //   return isFirstLaunch == null ? true : false;
  // }

  // @override
  // Future<void> setIsFirstLaunch(bool isFirstLaunch) async {
  //   final storage = await _completer.future;

  //   await storage.write(key: _IS_FIRST_LAUNCH, value: isFirstLaunch.toString());
  // }

  @override
  Future<bool?> clearUserData() async {
    final storage = await _completer.future;

    await storage.delete(key: _USERDATA);
    return true;
  }

  @override
  Future<String?> getUserRefreshToken() {
    // TODO: implement getUserRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getUserToken() {
    // TODO: implement getUserToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getUserTokenExpirationDate() {
    // TODO: implement getUserTokenExpirationDate
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUserRefreshToken(String userToken) {
    // TODO: implement saveUserRefreshToken
    throw UnimplementedError();
  }

  // @override
  // Future<bool> saveUserToken(String userToken) {
  //   // TODO: implement saveUserToken
  //   throw UnimplementedError();
  // }

  @override
  Future<bool> saveUserTokenExpirationDate(String userToken) {
    // TODO: implement saveUserTokenExpirationDate
    throw UnimplementedError();
  }

  @override
  Future<bool?> getUserIsLoggedIn() {
    // TODO: implement getUserIsLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUserIsLoggedIn(bool isLoggedIn) {
    // TODO: implement saveUserIsLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<bool?> isNotificationEnabled() {
    // TODO: implement isNotificationEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool> setNotificationStatus(bool isEnabled) {
    // TODO: implement setNotificationStatus
    throw UnimplementedError();
  }

  @override
  Future<bool?> isAdTrackingNotificationEnabled() {
    // TODO: implement isAdTrackingNotificationEnabled
    throw UnimplementedError();
  }

  @override
  Future<bool> setAdTrackingNotification(bool isEnabled) {
    // TODO: implement setAdTrackingNotification
    throw UnimplementedError();
  }

  @override
  Future<String?> getAppleUserData() {
    // TODO: implement getAppleUserData
    throw UnimplementedError();
  }

  @override
  Future<bool> saveAppleUserData(String userData) {
    // TODO: implement saveAppleUserData
    throw UnimplementedError();
  }

  @override
  Future<bool?> getUserThemeMode() {
    // TODO: implement getUserThemeMode
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUserThemeMode(bool isDark) {
    // TODO: implement saveUserThemeMode
    throw UnimplementedError();
  }

  @override
  Future<bool?> getIsFirstLunch() {
    // TODO: implement getIsFirstLunch
    throw UnimplementedError();
  }

  @override
  Future<bool> saveIsFirstLunch(bool isFirstLunch) {
    // TODO: implement saveIsFirstLunch
    throw UnimplementedError();
  }

  @override
  Future<List<String>?> getFavList() {
    // TODO: implement getFavList
    throw UnimplementedError();
  }

  @override
  Future<bool> saveFavList(List<String> favList) {
    // TODO: implement saveFavList
    throw UnimplementedError();
  }

  @override
  bool? isLogin() {
    // TODO: implement isLogin
    throw UnimplementedError();
  }

  @override
  Future<void> init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<void> setLogin(bool valuel) {
    // TODO: implement setLogin
    throw UnimplementedError();
  }

  @override
  String getSubCategryDriver() {
    // TODO: implement getSubCategryDriver
    throw UnimplementedError();
  }

  @override
  Future<void> setSubCategoryDriver({required String id}) {
    // TODO: implement setSubCategoryDriver
    throw UnimplementedError();
  }

  @override
  String getDriverId() {
    // TODO: implement getDriverId
    throw UnimplementedError();
  }

  @override
  Future<void> setDriverId({required String id}) {
    // TODO: implement setDriverId
    throw UnimplementedError();
  }

  @override
  Future<String?> getUserId() {
    // TODO: implement getUserId
    throw UnimplementedError();
  }

  @override
  Future<bool> setUserId(String userId) {
    // TODO: implement setUserId
    throw UnimplementedError();
  }

  @override
  Future<CheckAcceptByRiderModel> getDriverTripInfo() {
    // TODO: implement getDriverTripInfo
    throw UnimplementedError();
  }

  @override
  Future<CheckAcceptTripFromDriverModel> getRiderTripInfo() {
    // TODO: implement getRiderTripInfo
    throw UnimplementedError();
  }

  @override
  Future<void> saveDriverTripInfo({required CheckAcceptByRiderModel model}) {
    // TODO: implement saveDriverTripInfo
    throw UnimplementedError();
  }

  @override
  Future<void> saveRiderTripInfo(
      {required CheckAcceptTripFromDriverModel model}) {
    // TODO: implement saveRiderTripInfo
    throw UnimplementedError();
  }

  @override
  Future<void> removeDriverTripInfo() {
    // TODO: implement removeDriverTripInfo
    throw UnimplementedError();
  }

  @override
  Future<void> removeRiderTripInfo() {
    // TODO: implement removeRiderTripInfo
    throw UnimplementedError();
  }

  @override
  Future<String> getTripState() {
    // TODO: implement getTripState
    throw UnimplementedError();
  }

  @override
  Future<bool> saveTripState(String value) {
    // TODO: implement saveTripState
    throw UnimplementedError();
  }

  @override
  Future<void> removeTripState() {
    // TODO: implement removeTripState
    throw UnimplementedError();
  }
}
