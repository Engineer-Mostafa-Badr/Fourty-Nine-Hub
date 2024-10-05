import '../../domain/entity/vehicle_trip_join_entity.dart';

class VehicleTripJoinModel extends VehicleTripJoinEntity {
  VehicleTripJoinModel(
      {required super.id, required super.brand, required super.model});

  factory VehicleTripJoinModel.fromJson(Map<String, dynamic> json) {
    return VehicleTripJoinModel(
      id: json['_id'] ?? '',
      brand: json['Brand'] ?? '',
      model: json['Model'] ?? '',
    );
  }
}
