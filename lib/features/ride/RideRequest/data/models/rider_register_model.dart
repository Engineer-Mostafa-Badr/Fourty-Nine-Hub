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
  String? plateInfo;
  String? idExpiryDate;
  String? drvingExpiryDate;
  String? licenseExpiryDate;
  RiderRegisterModel({
    this.driverFirstName,
    this.driverLastName,
    this.vehicleModel,
    this.vehicleBrand,
    this.vehicleColor,
    this.vehicleType,
    this.vehicleYear,
    this.subcategoryId,
    this.yourFavoriteCity,
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
      "vehicleType": "vehicleType",
      "vehicleYear": vehicleYear,
      "subcategoryId": subcategoryId,
      "pricingPerKm": pricingPerKm,
      "phone": phone,
      "smoker": smoker,
      "airConditioner": airCondition,
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
      "plateInfo": plateInfo,
      "idNumber": idNumber
    };
  }
}
