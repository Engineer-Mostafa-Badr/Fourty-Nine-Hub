import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/history_ride/data/models/trip_model.dart';

abstract class HistoryRideRepo {
  Future<Either<Failure, List<TripModel>>> getTrips();
}
