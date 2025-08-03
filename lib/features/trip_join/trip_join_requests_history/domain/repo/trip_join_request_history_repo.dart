import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/tripjoin_request_entity.dart';
import '../entities/tripjoin_request_history_entity.dart';

abstract class TripJoinRequestHistoryRepo {
  Future<Either<Failure, List<TripJoinMyRequestEntity>>> fetchMyTripJoinAds(
      {required int page});
  Future<Either<Failure, bool>> deleteTrip(
      {required String subCategory, required String url, required String id});
  Future<Either<Failure, List<TripJoinRequestHistoryEntity>>> getRequests(
      {required String id, required int page});
}
