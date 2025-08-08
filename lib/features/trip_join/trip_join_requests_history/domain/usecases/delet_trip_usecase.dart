import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repo/trip_join_request_history_repo.dart';

class DeleteTripUseCase {
  final TripJoinRequestHistoryRepo tripJoinRequestHistoryRepo;

  DeleteTripUseCase({required this.tripJoinRequestHistoryRepo});
  Future<Either<Failure, bool>> call(
      {required String subCategory, required String url, required String id}) {
    return tripJoinRequestHistoryRepo.deleteTrip(
        subCategory: subCategory, url: url, id: id);
  }
}
