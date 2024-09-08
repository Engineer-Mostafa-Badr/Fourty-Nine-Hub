import 'dart:io';

import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class RegisterRequestModel {
  // SubCategoryEntity? subCategoryEntity;
  String? subCategoryId;
  String? firstName;
  String? lastName;
  // File? image;
  // File? plate;
  // File? carImageRight;
  // File? carImageLeft;
  // File? carImageBehind;
  File? carImageInFront;
  File? idImageBehind;
  File? idImageInFront;
  DateTime? idExpiryDate;
  File? drivingImageBehind;
  File? drivingImageInFront;
  DateTime? drivingExpiryDate;
  File? licenseImageBehind;
  File? licenseImageInFront;
  DateTime? licenseExpiryDate;
  String? model;
  String? phone;
  String? idNumber;
  String? plateInfromation;
  // GovernorateEntity? governorate;
  RegisterRequestModel({
    this.subCategoryId,
    this.firstName,
    this.lastName,
    this.idNumber,
    this.plateInfromation,
    this.carImageInFront,
    this.idImageBehind,
    this.idImageInFront,
    this.idExpiryDate,
    this.drivingImageBehind,
    this.drivingImageInFront,
    this.drivingExpiryDate,
    this.licenseImageBehind,
    this.licenseImageInFront,
    this.licenseExpiryDate,
    this.model,
    this.phone,
  });
}
