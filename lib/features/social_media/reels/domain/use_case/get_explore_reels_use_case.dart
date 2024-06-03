import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';

import '../repositories/reels_repository.dart';

class GetExploreReelsUseCase extends UseCase<List<ReelEntity>, int> {
  final ReelsRepository _repository;

  GetExploreReelsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ReelEntity>>> call(int params) {
    return _repository.getExploreReels(params);
  }
}
