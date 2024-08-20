import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/location_entity.dart';

abstract class TripJoinRepo {
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations(
      {required String address});
}
