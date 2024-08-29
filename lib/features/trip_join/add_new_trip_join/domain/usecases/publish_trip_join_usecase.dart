import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_join_publish_param.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/repo/trip_join_repo.dart';

class PublishTripJoinUseCase {
  final TripJoinRepo tripJoinRepo;

  PublishTripJoinUseCase({required this.tripJoinRepo});
  Future<Either<Failure, bool>> call({required TripJoinPublishParam tripJoinPublishParam}) async {
    return await tripJoinRepo.publishTripJoin(tripJoinPublishParam: tripJoinPublishParam);
  }
}
