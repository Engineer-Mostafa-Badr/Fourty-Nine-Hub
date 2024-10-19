import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';

import '../repositories/reels_repository.dart';

class LikeReelUseCase extends UseCase<ReelLikeResponse, String> {
  final ReelsRepository _repository;

  LikeReelUseCase(this._repository);

  @override
  Future<Either<Failure, ReelLikeResponse>> call(String params) {
    return _repository.likeReel(params);
  }
}
