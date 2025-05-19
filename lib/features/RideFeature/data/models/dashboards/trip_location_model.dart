import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_location_entity.dart';

class TripLocationModel extends TripLocationEntity{
  TripLocationModel({required super.title, required super.lat, required super.lng});

  //fromJson
  factory TripLocationModel.fromJson(Map<String, dynamic> json) {
    return TripLocationModel(
        title: json['title'] ?? '',
        lat: json['latitude'] ?? 0.0,
        lng: json['longitude'] ?? 0.0);
  }
}