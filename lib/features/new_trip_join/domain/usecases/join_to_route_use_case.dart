
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

import '../../../../core/error/failure.dart';

class JoinToRouteUseCase {
  final CaptainShareRepository repository;

  JoinToRouteUseCase(this.repository);

  Future<Either<Failure, MyBookingEntity>> call(JoinToRouteParams id) {
    return repository.joinToRoute(id);
  }
}

class JoinToRouteParams{
  final double lat;
  final double lng;
  final String routeId;

  JoinToRouteParams({required this.lat, required this.lng, required this.routeId});

  //toJson
  Map<String, dynamic> toJson() => {
    "pickupLocation": {
      "longitude": lng,
      "latitude": lat
    }
  };

}