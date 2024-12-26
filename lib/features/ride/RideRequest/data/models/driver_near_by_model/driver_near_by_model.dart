import 'location.dart';
import 'user_data.dart';

class DriverNearByModel {
  String? driverId;
  Location? location;
  double? distance;
  UserData? userData;

  DriverNearByModel({
    this.driverId,
    this.location,
    this.distance,
    this.userData,
  });

  factory DriverNearByModel.fromJson(Map<String, dynamic> json) {
    return DriverNearByModel(
      driverId: json['driverId'] as String?,
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      distance: (json['distance'] as num?)?.toDouble(),
      userData: json['userData'] == null
          ? null
          : UserData.fromJson(json['userData'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'location': location?.toJson(),
        'distance': distance,
        'userData': userData?.toJson(),
      };
}
