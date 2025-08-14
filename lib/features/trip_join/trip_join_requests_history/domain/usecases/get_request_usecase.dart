import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/tripjoin_request_history_entity.dart';
import '../repo/trip_join_request_history_repo.dart';

class GetRequestUsecase {
  final TripJoinRequestHistoryRepo tripJoinRequestHistoryRepo;

  GetRequestUsecase({required this.tripJoinRequestHistoryRepo});
  Future<Either<Failure, List<TripJoinRequestHistoryEntity>>> call(
      {required String id, required int page}) async {
    return tripJoinRequestHistoryRepo.getRequests(id: id, page: page);
  }
}
