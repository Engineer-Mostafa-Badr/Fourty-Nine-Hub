import 'dart:io';

class RiderRegisterModel {
  String? driverFirstName;
  String? driverLastName;
  String? vehicleModel;
  String? vehicleBrand;
  String? vehicleColor;
  String? vehicleYear;
  String? subcategoryId;
  double? pricingPerKm;
  String? phone;
  bool? smoker;
  bool? airCondition;
  File? carImage;
  File? idImageInFront;
  File? idImageInBehind;
  File? drivingImageInFront;
  File? drivingImageBehind;
  File? licenseImageInFront;
  File? licenseImgeBehind;
  String? idNumber;
  String? driverLicenseNumber;
  List<String>? subcategoryIds;
  String? workingType;
  String? plateInfo;
  String? idExpiryDate;
  String? drvingExpiryDate;
  String? licenseExpiryDate;
  File? driverImage;
  DateTime? birthDate;
  File? verfiyUserImage;
  File? carLicenseFrontImage;
  File? carLicenseBehindImage;
  File? dragAnalysis;
  String? dragAnalysisDate;
  File? criminalRecordImage;
  String? criminalRecordDate;
  File? technicalExaminationImage;
  String? carModel;
  String? technicalExaminationDate;
  String? governorateNameAr;
  RiderRegisterModel({
    this.driverFirstName,
    this.driverLastName,
    this.workingType,
    this.vehicleModel,
    this.vehicleBrand,
    this.vehicleColor,
    this.technicalExaminationImage,
    this.technicalExaminationDate,
    this.criminalRecordImage,
    this.criminalRecordDate,
    this.carModel,
    this.birthDate,
    this.verfiyUserImage,
    this.subcategoryIds,
    this.vehicleYear,
    this.driverImage,
    this.subcategoryId,
    this.pricingPerKm,
    this.phone,
    this.smoker,
    this.airCondition,
    this.carImage,
    this.idImageInBehind,
    this.drivingImageBehind,
    this.drivingImageInFront,
    this.drvingExpiryDate,
    this.idExpiryDate,
    this.idImageInFront,
    this.driverLicenseNumber,
    this.idNumber,
    this.governorateNameAr,
    this.licenseExpiryDate,
    this.licenseImageInFront,
    this.licenseImgeBehind,
    this.plateInfo,
  });
  Map<String, dynamic> registerOne() {
    return {
      "driverFirstName": driverFirstName,
      "driverLastName": driverLastName,
      "vehicleModel": vehicleModel,
      "vehicleBrand": vehicleBrand,
      "vehicleYear": vehicleYear,
      "subcategoryIds": subcategoryIds,
      "pricingPerKm": pricingPerKm,
      "phone": phone,
      "smoker": smoker ?? false,
      "airConditioner": airCondition ?? false,
      "city": governorateNameAr,
      "plateInfo": plateInfo,
      "idNumber": "idNumber",
      "workingType": workingType,
      "vehicleColor": vehicleColor,
      "birthday": birthDate.toString(),
      "driverLicenseNumber": driverLicenseNumber
    };
  }

  Map<String, dynamic> registerTow() {
    return {
      "driverFirstName": driverFirstName,
      "driverLastName": driverLastName,
      "carModel": carModel,
      "subcategoryId": subcategoryId,
      "phone": phone,
      "plateInfo": plateInfo,
      "idNumber": idNumber,
      "birthday": birthDate.toString(),
      "driverLicenseNumber": driverLicenseNumber,
    };
  }
}
