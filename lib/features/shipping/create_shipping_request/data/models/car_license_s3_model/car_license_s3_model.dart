import 'car_license_behind.dart';
import 'car_license_front.dart';

class CarLicenseS3Model {
  String? expireDate;
  CarLicenseFront? carLicenseFront;
  CarLicenseBehind? carLicenseBehind;

  CarLicenseS3Model({
    this.expireDate,
    this.carLicenseFront,
    this.carLicenseBehind,
  });

  factory CarLicenseS3Model.fromJson(Map<String, dynamic> json) {
    return CarLicenseS3Model(
      expireDate: json['expireDate'] as String?,
      carLicenseFront: json['carLicenseFront'] == null
          ? null
          : CarLicenseFront.fromJson(
              json['carLicenseFront'] as Map<String, dynamic>),
      carLicenseBehind: json['carLicenseBehind'] == null
          ? null
          : CarLicenseBehind.fromJson(
              json['carLicenseBehind'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'expireDate': expireDate,
        'carLicenseFront': carLicenseFront?.toJson(),
        'carLicenseBehind': carLicenseBehind?.toJson(),
      };
}
