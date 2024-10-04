import 'driver_information.dart';

class GetDriverDataModel {
  DriverInformation? driverInformation;

  GetDriverDataModel({this.driverInformation});

  factory GetDriverDataModel.fromJson(Map<String, dynamic> json) {
    return GetDriverDataModel(
      driverInformation: json['DriverInformation'] == null
          ? null
          : DriverInformation.fromJson(
              json['DriverInformation'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'DriverInformation': driverInformation?.toJson(),
      };
}
