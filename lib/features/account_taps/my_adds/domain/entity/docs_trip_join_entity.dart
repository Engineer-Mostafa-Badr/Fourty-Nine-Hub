import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/category_trip_join_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/vehicle_trip_join_entity.dart';

class DocsTripJoinEntity {
  final String id;
  final String fromAr;
  final String toAr;
  final String fromEn;
  final String toEn;
  final int distance;
  final int duration;
  final int passengers;
  final int price;
  final String phone;
  final int time;
  final String countryCode;
  final int countRequests;
  final List<dynamic> calls;
  final bool isRepeat;
  final String status;
  final int statusPriority;
  final bool adminIgnore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CategoryTripJoinEntity categoryId;
  final VehicleTripJoinEntity vehicleId;

  DocsTripJoinEntity(
      {required this.id,
      required this.fromAr,
      required this.toAr,
      required this.fromEn,
      required this.toEn,
      required this.distance,
      required this.duration,
      required this.passengers,
      required this.price,
      required this.phone,
      required this.time,
      required this.countryCode,
      required this.countRequests,
      required this.calls,
      required this.isRepeat,
      required this.status,
      required this.statusPriority,
      required this.adminIgnore,
      required this.createdAt,
      required this.updatedAt,
      required this.categoryId,
      required this.vehicleId,
      });
}
