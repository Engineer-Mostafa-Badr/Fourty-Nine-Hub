import 'driving_license_behind.dart';
import 'driving_license_front.dart';

class DrivnigLicenseS3Model {
  String? expireDate;
  DrivingLicenseFront? drivingLicenseFront;
  DrivingLicenseBehind? drivingLicenseBehind;

  DrivnigLicenseS3Model({
    this.expireDate,
    this.drivingLicenseFront,
    this.drivingLicenseBehind,
  });

  factory DrivnigLicenseS3Model.fromJson(Map<String, dynamic> json) {
    return DrivnigLicenseS3Model(
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
