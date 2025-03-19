import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/dashboards/trips_response_entity.dart';

abstract class TripRepository {
   Future<Either<Failure, TripsResponseEntity>> getAvailableTrips(String params);
   Future<Either<Failure, TripsResponseEntity>> getPastTrips();
}