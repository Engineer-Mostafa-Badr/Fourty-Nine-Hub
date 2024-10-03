import 'location.dart';
import 'user_data.dart';

class Driver {
  String? driverId;
  Location? location;
  UserData? userData;

  Driver({this.driverId, this.location, this.userData});

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        driverId: json['driverId'] as String?,
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        userData: json['userData'] == null
            ? null
            : UserData.fromJson(json['userData'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'location': location?.toJson(),
        'userData': userData?.toJson(),
      };
}
