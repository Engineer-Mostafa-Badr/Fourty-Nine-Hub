import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/trip_join_publish_param.dart';
import '../repo/trip_join_repo.dart';

class PublishTripJoinUseCase {
  final TripJoinRepo tripJoinRepo;

  PublishTripJoinUseCase({required this.tripJoinRepo});
  Future<Either<Failure, bool>> call(
      {required TripJoinPublishParam tripJoinPublishParam}) async {
    return await tripJoinRepo.publishTripJoin(
        tripJoinPublishParam: tripJoinPublishParam);
  }
}
