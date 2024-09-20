import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_history_entity.dart';

abstract class TripJoinRequestHistoryRepo {
  Future<Either<Failure, List<TripJoinMyRequestEntity>>> fetchMyTripJoinAds(
      {required int page});
  Future<Either<Failure, bool>> deleteTrip({required String id});
  Future<Either<Failure, List<TripJoinRequestHistoryEntity>>> getRequests(
      {required String id, required int page});
}
