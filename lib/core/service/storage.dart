import 'dart:convert';

import 'package:fourtyninehub/core/constants/constants.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/dashboards/refuse_model.dart';
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

///=======================================================================>

  // Add a new model to SharedPreferences
  Future<void> addRefuseModel(RefuseModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existingModels = prefs.getStringList(Constants.refuseTrips) ?? [];

    // Add new model
    existingModels.add(json.encode(model.toMap()));

    await prefs.setStringList(Constants.refuseTrips, existingModels);
  }

  // Get all non-expired models (automatically removes expired ones)
  Future<List<RefuseModel>> getValidModels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? modelStrings = prefs.getStringList(Constants.refuseTrips);

    if (modelStrings == null || modelStrings.isEmpty) {
      return [];
    }

    final List<RefuseModel> validModels = [];
    final List<String> validModelStrings = [];
    final DateTime now = DateTime.now();

    for (final modelString in modelStrings) {
      try {
        final RefuseModel model = RefuseModel.fromMap(json.decode(modelString));
        final Duration difference = now.difference(model.createdAt);

        // Check if less than 15 minutes (900 seconds) have passed
        if (difference.inSeconds < 900) {
          validModels.add(model);
          validModelStrings.add(modelString);
        }
      } catch (e) {
        // Skip corrupted entries
        continue;
      }
    }

    // Update storage with only valid models
    await prefs.setStringList(Constants.refuseTrips, validModelStrings);

    return validModels;
  }

  // Clear all models from storage
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.refuseTrips);
  }
}

