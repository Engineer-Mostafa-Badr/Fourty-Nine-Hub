

import 'package:fourtyninehub/features/ride/Authentication/data/models/basic_info_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/car_licence_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/drag_analysis_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/driver_licence_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/more_info_part_model.dart';

abstract class BasePartModel {
  toJson();
  factory BasePartModel.fromJson({required Map<String, dynamic>? json, required String type}) {
    switch (type) {
      case 'basicInfo':
        return BasicInfoPartModel.fromJson(json);
      case 'carLicence':
        return CarLicencePartModel.fromJson(json);
      case 'dragAnalysisPart':
        return DragAnalysisPartModel.fromJson(json);
      case 'driverLicence':
        return DriverLicencePartModel.fromJson(json);
      case 'moreInfo':
        return MoreInfoPartModel.fromJson(json);
      default:
        return BasicInfoPartModel.fromJson(json);
    }
  }
}