import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required super.place,
    required super.lat,
    required super.log,
  });
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      place: json['place'] ?? '',
      lat: json['lat'] ?? '',
      log: json['long'] ?? '',
    );
  }
}
