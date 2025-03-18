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
  final bool airConditioner;
  final String city;
  final String plateInfo;
  final String idNumber;
  final String workingType;
  final String vehicleColor;
  final String birthday;
  final String driverLicenseNumber;

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
      }
    };
  }
}