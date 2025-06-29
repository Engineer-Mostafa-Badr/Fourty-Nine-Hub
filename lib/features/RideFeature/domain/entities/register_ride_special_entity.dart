import 'package:flutter_image_compress/flutter_image_compress.dart';

class RegisterRideSpecialEntity {
  final String driverFirstName;
  final String driverLastName;
  final String vehicleModel;
  final String vehicleBrand;
  final String vehicleYear;
  final List<String> subcategoryIds;
  final String pricingPerKm;
  final String phone;
  final bool smoker;
  final bool? isShipping;
  final bool airConditioner;
  final String city;
  final String plateInfo;
  final String idNumber;
  final String workingType;
  final String vehicleColor;
  final String birthday;
  final String driverLicenseNumber;
  final String? personalPicture;

  RegisterRideSpecialEntity({
    required this.driverFirstName,
    required this.driverLastName,
    required this.vehicleModel,
    required this.vehicleBrand,
    required this.vehicleYear,
    required this.subcategoryIds,
    required this.pricingPerKm,
    required this.phone,
    required this.smoker,
    required this.airConditioner,
    required this.city,
    required this.plateInfo,
    required this.idNumber,
    required this.workingType,
    required this.vehicleColor,
    required this.birthday,
    required this.driverLicenseNumber,
    this.personalPicture,
    this.isShipping,
  });

  //toJson
  Map<String, dynamic> toJson() {
    return {
      "driverInfo": {
        "firstName": driverFirstName,
        "lastName": driverLastName,
        "dateOfBirth": birthday,
        "identificationDetails": {
          "driverLicenseNumber": driverLicenseNumber,
          "nationalIdNumber": idNumber,
        },
        "contactInfo": {
          "phoneNumber": phone,
          "city": city,
        }
      },
      "vehicleInfo": {
        "brandId": vehicleBrand,
        "modelId": vehicleModel,
        "color": vehicleColor,
        "year": vehicleYear,
        "plateDetails": plateInfo,
        "features": {
          "hasAirConditioner": airConditioner,
          "allowsSmoking": smoker,
        }
      },
      "serviceSettings": {
        "pricingPerKm": pricingPerKm,
        "workingType": workingType,
        "subcategoryIds": subcategoryIds,
      }
    };
  }

  //toJson
  Map<String, dynamic> toCacheJson() {
    return {
      "driverInfo": {
        "firstName": driverFirstName,
        "lastName": driverLastName,
        "dateOfBirth": birthday,
        "identificationDetails": {
          "driverLicenseNumber": driverLicenseNumber,
          "nationalIdNumber": idNumber,
        },
        "contactInfo": {
          "phoneNumber": phone,
          "city": city,
        }
      },
      "vehicleInfo": {
        "brand": vehicleBrand,
        "model": vehicleModel,
        "color": vehicleColor,
        "year": vehicleYear,
        "plateDetails": plateInfo,
        "features": {
          "hasAirConditioner": airConditioner,
          "allowsSmoking": smoker,
        }
      },
      "serviceSettings": {
        "pricingPerKm": pricingPerKm,
        "workingType": workingType,
        "subcategoryIds": subcategoryIds,
      },
      "personalPicture":personalPicture,
      "isShipping":isShipping
    };
  }

  // fromJson factory method
  factory RegisterRideSpecialEntity.fromJson(Map<String, dynamic> json) {
    final driverInfo = json["driverInfo"];
    final identificationDetails = driverInfo["identificationDetails"];
    final contactInfo = driverInfo["contactInfo"];
    final vehicleInfo = json["vehicleInfo"];
    final features = vehicleInfo["features"];
    final serviceSettings = json["serviceSettings"];

    return RegisterRideSpecialEntity(
      driverFirstName: driverInfo["firstName"],
      driverLastName: driverInfo["lastName"],
      birthday: driverInfo["dateOfBirth"],
      driverLicenseNumber: identificationDetails["driverLicenseNumber"],
      idNumber: identificationDetails["nationalIdNumber"],
      phone: contactInfo["phoneNumber"],
      city: contactInfo["city"],
      vehicleBrand: vehicleInfo["brand"],
      vehicleModel: vehicleInfo["model"],
      vehicleColor: vehicleInfo["color"],
      vehicleYear: vehicleInfo["year"],
      plateInfo: vehicleInfo["plateDetails"],
      airConditioner: features["hasAirConditioner"],
      smoker: features["allowsSmoking"],
      pricingPerKm: serviceSettings["pricingPerKm"],
      workingType: serviceSettings["workingType"],
      subcategoryIds: List<String>.from(serviceSettings["subcategoryIds"]),
      personalPicture:json["personalPicture"],
      isShipping:json["isShipping"],
    );
  }
}