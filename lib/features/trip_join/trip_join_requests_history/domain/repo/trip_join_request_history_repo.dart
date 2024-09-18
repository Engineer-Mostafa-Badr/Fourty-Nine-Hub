import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_entity.dart';

abstract class TripJoinRequestHistoryRepo {
  Future<Either<Failure, List<TripJoinMyRequestEntity>>> fetchMyTripJoinAds({required int page});
}
