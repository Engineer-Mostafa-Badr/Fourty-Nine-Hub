import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/trip_join_requests_history/domain/repo/trip_join_request_history_repo.dart';

class DeleteTripUseCase {
  final TripJoinRequestHistoryRepo tripJoinRequestHistoryRepo;

  DeleteTripUseCase({required this.tripJoinRequestHistoryRepo});
  Future<Either<Failure, bool>> call(
      {required String subCategory, required String url, required String id}) {
    return tripJoinRequestHistoryRepo.deleteTrip(
        subCategory: subCategory, url: url, id: id);
  }
}
