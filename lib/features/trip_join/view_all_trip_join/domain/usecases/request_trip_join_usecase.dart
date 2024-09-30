// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/repos/view_all_trip_join_repo.dart';

class RequstTripJoinUseCase {
  ViewAllTripJoinRepo viewAllTripJoinRepo;
  RequstTripJoinUseCase({
    required this.viewAllTripJoinRepo,
  });
  Future<Either<Failure, bool>> call({required String addId, required String mobile, bool premuimRequest = false}) {
    return viewAllTripJoinRepo.requestTripJoin(
      addId: addId,
      mobile: mobile,
      premuimRequest: premuimRequest,
    );
  }
}
