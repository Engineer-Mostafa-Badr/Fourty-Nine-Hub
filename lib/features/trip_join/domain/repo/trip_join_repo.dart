import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/trip_info_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripJoinRepo {
  Future<Either<Failure, TripInfoEntity>> fetchDistancePrice({
    required LatLng startLocation,
    required LatLng destinationLocation,
  });
}
