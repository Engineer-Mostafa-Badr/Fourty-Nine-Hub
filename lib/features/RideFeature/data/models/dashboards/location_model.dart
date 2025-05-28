import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel(
      {required super.title, 
      // required CoordinatesModel super.coordinates
      });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title']??'',
      // coordinates: CoordinatesModel.fromJson(json['coordinates']),
    );
  }
}

// coordinates_model.dart
class CoordinatesModel extends CoordinatesEntity {
  const CoordinatesModel({required super.lat, required super.lng});

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      lat: json['lat']??0,
      lng: json['lng']??0,
    );
  }
}
