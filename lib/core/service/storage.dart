import 'dart:convert';

import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  // Save driver entity to SharedPreferences
  Future<bool> saveDriverEntity(RegisterRideSpecialEntity entity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String entityJson = jsonEncode(entity.toCacheJson());
    return await prefs.setString(Constants.rideSpecialDriver, entityJson);
  }

  // Get driver entity from SharedPreferences
  Future<RegisterRideSpecialEntity?> getDriverEntity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? entityJson = prefs.getString(Constants.rideSpecialDriver);

    if (entityJson == null || entityJson.isEmpty) {
      return null;
    }

    try {
      return RegisterRideSpecialEntity.fromJson(jsonDecode(entityJson));
    } catch (e) {
      print('Error parsing driver entity: $e');
      return null;
    }
  }

  // Remove driver entity from SharedPreferences
  Future<bool> removeDriverEntity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(Constants.rideSpecialDriver);
  }


  // Save driver no socket entity to SharedPreferences
  Future<bool> saveDriverNoSocketEntity(RegisterRideNotSpecialEntity entity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String entityJson = jsonEncode(entity.toJson());
    return await prefs.setString(Constants.rideNotSpecialDriver, entityJson);
  }

  // Get driver entity from SharedPreferences
  Future<RegisterRideNotSpecialEntity?> getDriverNoSocketEntity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? entityJson = prefs.getString(Constants.rideNotSpecialDriver);

    if (entityJson == null || entityJson.isEmpty) {
      return null;
    }

    try {
      return RegisterRideNotSpecialEntity.fromJson(jsonDecode(entityJson));
    } catch (e) {
      print('Error parsing driver entity: $e');
      return null;
    }
  }

  // Remove driver entity from SharedPreferences
  Future<bool> removeDriverNoSocketEntity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(Constants.rideNotSpecialDriver);
  }

  // Save driver no socket entity to SharedPreferences
  Future<bool> saveLoaderEntity(LoadingRegisterEntity entity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String entityJson = jsonEncode(entity.toJson());
    return await prefs.setString(Constants.loaderRegister, entityJson);
  }

  // Get driver entity from SharedPreferences
  Future<LoadingRegisterEntity?> getLoaderEntity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? entityJson = prefs.getString(Constants.loaderRegister);

    if (entityJson == null || entityJson.isEmpty) {
      return null;
    }

    try {
      return LoadingRegisterEntity.fromJson(jsonDecode(entityJson));
    } catch (e) {
      print('Error parsing driver entity: $e');
      return null;
    }
  }

  // Remove driver entity from SharedPreferences
  Future<bool> removeLoaderEntity() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(Constants.loaderRegister);
  }
}

