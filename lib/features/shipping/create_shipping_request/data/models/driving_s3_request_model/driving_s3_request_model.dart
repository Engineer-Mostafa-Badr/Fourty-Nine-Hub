import 'driving_license_behind.dart';
import 'driving_license_front.dart';

class DrivingS3RequestModel {
  String? expireDate;
  DrivingLicenseFront? drivingLicenseFront;
  DrivingLicenseBehind? drivingLicenseBehind;

  DrivingS3RequestModel({
    this.expireDate,
    this.drivingLicenseFront,
    this.drivingLicenseBehind,
  });

  factory DrivingS3RequestModel.fromJson(Map<String, dynamic> json) {
    return DrivingS3RequestModel(
      expireDate: json['expireDate'] as String?,
      drivingLicenseFront: json['drivingLicenseFront'] == null
          ? null
          : DrivingLicenseFront.fromJson(
              json['drivingLicenseFront'] as Map<String, dynamic>),
      drivingLicenseBehind: json['drivingLicenseBehind'] == null
          ? null
          : DrivingLicenseBehind.fromJson(
              json['drivingLicenseBehind'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'expireDate': expireDate,
        'drivingLicenseFront': drivingLicenseFront?.toJson(),
        'drivingLicenseBehind': drivingLicenseBehind?.toJson(),
      };
}
