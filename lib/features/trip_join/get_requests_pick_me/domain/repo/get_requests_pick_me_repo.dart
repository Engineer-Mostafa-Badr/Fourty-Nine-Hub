import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/get_requests_pick_me/data/models/get_requests_pick_me_model.dart';

abstract class GetRequestsPickMeRepo {
  Future<Either<Failure, List<TripDataWithRequests>>> getRequestsPickMe();
}
