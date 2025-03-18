import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({required super.type, required super.coordinates});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
}