import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/entities/tripjoin_request_history_entity.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/repo/trip_join_request_history_repo.dart';

class GetRequestUsecase {
  final TripJoinRequestHistoryRepo tripJoinRequestHistoryRepo;

  GetRequestUsecase({required this.tripJoinRequestHistoryRepo});
  Future<Either<Failure, List<TripJoinRequestHistoryEntity>>> call(
      {required String id, required int page}) async {
    return tripJoinRequestHistoryRepo.getRequests(id: id, page: page);
  }
}
