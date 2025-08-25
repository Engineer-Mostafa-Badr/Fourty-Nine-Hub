import 'package:fourtyninehub/features/new_trip_join/domain/entities/pickup_entity.dart';

class PickupModel extends PickupEntity {
  PickupModel({required super.polyline, required super.expectedArrivalDuration, required super.currentPickupTime});

  factory PickupModel.fromJson(Map<String, dynamic> json) {
    return PickupModel(
      polyline: json['polyline'],
      expectedArrivalDuration: json['expectedArrivalDuration'],
      currentPickupTime: json['currentPickupTime'],
    );
  }
}