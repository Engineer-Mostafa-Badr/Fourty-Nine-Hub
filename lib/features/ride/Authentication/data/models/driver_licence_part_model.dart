import 'package:fourtyninehub/features/ride/Authentication/data/models/base_part_model.dart';

class DriverLicencePartModel implements BasePartModel {
  String? driverLicenseNumber;
  String? frontDriverLicense;
  String? backDriverLicense;
  String? expirationDate;
  String? identify;
  DriverLicencePartModel(
      {this.backDriverLicense,
      this.driverLicenseNumber,
      this.expirationDate,
      this.frontDriverLicense,
      this.identify});
  factory DriverLicencePartModel.fromJson(Map<String, dynamic>? json) {
    return DriverLicencePartModel(
      backDriverLicense: json?['backDriverLicense'],
      driverLicenseNumber: json?['driverLicenseNumber'],
      expirationDate: json?['expirationDate'],
      frontDriverLicense: json?['frontDriverLicense'],
      identify: json?['identify'],
    );
  }
  @override
  toJson() {
    return {
      "backDriverLicense": backDriverLicense,
      "driverLicenseNumber": driverLicenseNumber,
      "expirationDate": expirationDate,
      "frontDriverLicense": frontDriverLicense,
      "identify": identify,
    };
  }
}
