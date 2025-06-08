class RegisterRideNotSpecialEntity {
  final String driverFirstName;
  final String driverLastName;
  final String carModel;
  final String subcategoryId;
  final String phone;
  final String plateInfo;
  final String idNumber;
  final String birthday;
  final String driverLicenseNumber;
  final String vehicleModel;
  final String vehicleBrand;
  final String vehicleYear;
  final String vehicleColor;

  RegisterRideNotSpecialEntity({
    required this.driverFirstName,
    required this.driverLastName,
    required this.carModel,
    required this.subcategoryId,
    required this.phone,
    required this.plateInfo,
    required this.idNumber,
    required this.birthday,
    required this.driverLicenseNumber,
    required this.vehicleModel,
    required this.vehicleBrand,
    required this.vehicleYear,
    required this.vehicleColor,
  });

  Map<String, dynamic> toJson() {
    return{
      "driverFirstName" : driverFirstName,
    "driverLastName": driverLastName,
    // "carModel" : "ميكروباص شيفرليه",
    "carModelId": vehicleModel,
    "carBrandId": vehicleBrand,
    "vehicleColor": vehicleColor,
    "vehicleYear": vehicleYear,
    "subcategoryId": subcategoryId,
    "phone": phone,
    "plateInfo" : plateInfo,
    "idNumber" : idNumber,
    "birthday": birthday,
    "driverLicenseNumber":driverLicenseNumber
  };
  }

  //fromJson
  factory RegisterRideNotSpecialEntity.fromJson(Map<String, dynamic> json) {
    return RegisterRideNotSpecialEntity(
      driverFirstName: json['driverFirstName'],
      driverLastName: json['driverLastName'],
      carModel: json['carModel'],
      subcategoryId: json['subcategoryId'],
      phone: json['phone'],
      plateInfo: json['plateInfo'],
      idNumber: json['idNumber'],
      birthday: json['birthday'],
      driverLicenseNumber: json['driverLicenseNumber'],
      vehicleModel: json['carModelId'],
      vehicleBrand: json['carBrandId'],
      vehicleYear: json['carYear'],
      vehicleColor: json['carColor'],
    );
  }
}