import 'package:fourtyninehub/features/account_taps/my_adds/data/model/category_trip_join_model.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/data/model/vehicle_trip_join_model.dart';

import '../../domain/entity/docs_trip_join_entity.dart';

class DocsTripJoinModel extends DocsTripJoinEntity {
  DocsTripJoinModel(
      {required super.id,
      required super.fromAr,
      required super.toAr,
      required super.fromEn,
      required super.toEn,
      required super.distance,
      required super.duration,
      required super.passengers,
      required super.price,
      required super.phone,
      required super.time,
      required super.countryCode,
      required super.countRequests,
      required super.calls,
      required super.isRepeat,
      required super.status,
      required super.statusPriority,
      required super.adminIgnore,
      required super.createdAt,
      required super.updatedAt,
      required super.categoryId,
      required super.vehicleId});
  factory DocsTripJoinModel.fromJson(Map<String, dynamic> json) {
    return DocsTripJoinModel(
      id: json['_id'] ?? '',
      fromAr: json['fromAr'] ?? '',
      toAr: json['toAr'] ?? '',
      fromEn: json['fromEn'] ?? '',
      toEn: json['toEn'] ?? '',
      distance: json['distance'] ?? 0,
      duration: json['duration'] ?? 0,
      passengers: json['passengers'] ?? 1,
      price: json['price'] ?? 0,
      phone: json['phone'] ?? '',
      time: json['time'] ?? 0,
      countryCode: json['countryCode'] ?? '',
      countRequests: json['countRequests'] ?? 0,
      calls: List<dynamic>.from(json['calls']),
      isRepeat: json['isRepeat'] ?? false,
      status: json['status'] ?? '',
      statusPriority: json['statusPriority'] ?? 0,
      adminIgnore: json['adminIgnore'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      categoryId: CategoryTripJoinModel.fromJson(json['categoryId']),
      vehicleId: VehicleTripJoinModel.fromJson(json['vehicleId']),
    );
  }
}
