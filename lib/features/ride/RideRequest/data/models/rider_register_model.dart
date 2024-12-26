import 'dart:io';

class RiderRegisterModel {
  String? driverFirstName;
  String? driverLastName;
  String? vehicleModel;
  String? vehicleBrand;
  String? vehicleColor;
  String? vehicleType;
  String? vehicleYear;
  String? subcategoryId;
  String? yourFavoriteCity;
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
  List<String>? subcategoryIds;
  String? workingType;
  String? plateInfo;
  String? idExpiryDate;
  String? drvingExpiryDate;
  String? licenseExpiryDate;
  String? carModel;
  RiderRegisterModel({
    this.driverFirstName,
    this.driverLastName,
    this.workingType,
    this.vehicleModel,
    this.vehicleBrand,
    this.vehicleColor,
    this.vehicleType,
    this.subcategoryIds,
    this.vehicleYear,
    this.subcategoryId,
    this.yourFavoriteCity,
    this.carModel,
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
    this.idNumber,
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
      "vehicleColor": "vehicleColor",
      "vehicleType": vehicleType ?? 'car',
      "vehicleYear": vehicleYear,
      "workingType": workingType ?? "percentage",
      "subcategoryIds": subcategoryIds,
      "pricingPerKm": pricingPerKm,
      "phone": phone,
      "smoker": smoker ?? false,
      "airConditioner": airCondition ?? false,
      "city": "cairo",
      "plateInfo": plateInfo,
      "idNumber": idNumber,
    };
  }

  Map<String, dynamic> registerTow() {
    return {
      "driverFirstName": driverFirstName,
      "driverLastName": driverLastName,
      "subcategoryId": subcategoryId,
      "phone": phone,
      "carModel": carModel,
      "plateInfo": plateInfo,
      "idNumber": idNumber
    };
  }
}
