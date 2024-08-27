import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel(
      {
        required super.formattedAddress,
        required super.name,
        required super.lat,
        required super.lng,
      });
  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      formattedAddress: json['formatted_address'] ?? '',
      name: json['name'] ?? '',
      lat: json['geometry']['location']['lat'] ?? 0.0,
      lng: json['geometry']['location']['lng'] ?? 0.0,
    );
  }
}
