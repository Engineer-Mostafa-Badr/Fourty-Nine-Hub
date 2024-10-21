import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';

import '../repositories/reels_repository.dart';

class GetFollowersReelsUseCase extends UseCase<ReelsResponse, int> {
  final ReelsRepository _repository;

  GetFollowersReelsUseCase(this._repository);

  @override
  Future<Either<Failure, ReelsResponse>> call(int params) {
    return _repository.getFollowersReels(params);
  }
}
