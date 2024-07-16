import '../../domain/entities/restaurant_location_entity.dart';

class RestaurantLocationModel extends RestaurantLocationEntity {
  RestaurantLocationModel(
      {required super.type,
      required super.coordinates,
      required super.readableName,
      required super.id});
  factory RestaurantLocationModel.fromJson(Map<String, dynamic> json) {
    return RestaurantLocationModel(
      type: json['type'],
      coordinates: json['coordinates'].cast<double>(),
      readableName: json['readableName'],
      id: json['_id'],
    );
  }
}
