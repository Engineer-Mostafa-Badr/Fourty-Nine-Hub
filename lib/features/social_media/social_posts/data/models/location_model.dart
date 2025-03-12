import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required super.place,
    required super.lat,
    required super.log,
  });
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      place: json['name'] ?? '',
      lat: ((json['coordinates'] !=null&& json['coordinates'].isNotEmpty) ? json['coordinates'][0] : 0)?? 0,
      log: ((json['coordinates'] !=null&& json['coordinates'].isNotEmpty) ? json['coordinates'][1] : 0)?? 0,
    );
  }
}
