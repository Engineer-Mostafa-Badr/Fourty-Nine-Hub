import 'dart:io';

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
