import 'driver.dart';
import 'trip_info.dart';

class RequestSocketResponse {
  List<Driver>? drivers;
  TripInfo? tripInfo;

  RequestSocketResponse({this.drivers, this.tripInfo});

  factory RequestSocketResponse.fromJson(Map<String, dynamic> json) {
    return RequestSocketResponse(
      drivers: (json['drivers'] as List<dynamic>?)
          ?.map((e) => Driver.fromJson(e as Map<String, dynamic>))
          .toList(),
      tripInfo: json['tripInfo'] == null
          ? null
          : TripInfo.fromJson(json['tripInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'drivers': drivers?.map((e) => e.toJson()).toList(),
        'tripInfo': tripInfo?.toJson(),
      };
}
