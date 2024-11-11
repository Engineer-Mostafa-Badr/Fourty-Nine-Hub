import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/fetch_my_pick_me_trips/data/models/fetch_my_pick_me_model.dart';

abstract class FetchMyPickMeRepo {
  Future<Either<Failure, List<TripData>>> fetchMyPickMeTrips(
      {required int page});
}
