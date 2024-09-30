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
          id: json['id'] as String,
          fromAr: json['fromAr'] as String,
          toAr: json['toAr'] as String,
          fromEn: json['fromEn'] as String,
          toEn: json['toEn'] as String,
          distance: json['distance'] as int,
          duration: json['duration'] as int,
          passengers: json['passengers'] as int,
          price: json['price'] as int,
          phone: json['phone'] as String,
          time: json['time'] as int,
          countryCode: json['countryCode'] as String,
          countRequests: json['countRequests'] as int,
          calls: List<dynamic>.from(json['calls']),
          isRepeat: json['isRepeat'] as bool,
          status: json['status'] as String,
          statusPriority: json['statusPriority'] as int,
          adminIgnore: json['adminIgnore'] as bool,
          createdAt: DateTime.parse(json['createdAt'] as String),
          updatedAt: DateTime.parse(json['updatedAt'] as String),
          categoryId: CategoryTripJoinModel.fromJson(json['categoryId']),
          vehicleId: VehicleTripJoinModel.fromJson(json['vehicleId']),
      );
  }
}
