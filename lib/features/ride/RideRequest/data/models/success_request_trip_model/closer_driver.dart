import 'location.dart';
import 'user_data.dart';

class CloserDriver {
  String? driverId;
  Location? location;
  double? distance;
  UserData? userData;

  CloserDriver({
    this.driverId,
    this.location,
    this.distance,
    this.userData,
  });

  factory CloserDriver.fromJson(Map<String, dynamic> json) => CloserDriver(
        driverId: json['driverId'] as String?,
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        distance: (json['distance'] as num?)?.toDouble(),
        userData: json['userData'] == null
            ? null
            : UserData.fromJson(json['userData'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'location': location?.toJson(),
        'distance': distance,
        'userData': userData?.toJson(),
      };
}
