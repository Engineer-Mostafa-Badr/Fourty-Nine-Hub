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
  });

  Map<String, dynamic> toJson() {
    return {
      "driverFirstName": driverFirstName,
      "driverLastName": driverLastName,
      "carModel": carModel,
      "subcategoryId": subcategoryId,
      "phone": phone,
      "plateInfo": plateInfo,
      "idNumber": idNumber,
      "birthday": birthday,
      "driverLicenseNumber": driverLicenseNumber
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
    );
  }
}