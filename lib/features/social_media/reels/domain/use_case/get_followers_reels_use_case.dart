import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/new_reels_model.dart';

import '../repositories/reels_repository.dart';

class GetFollowingReelsUseCase extends UseCase<ReelsResponse, int> {
  final ReelsRepository _repository;

  GetFollowingReelsUseCase(this._repository);

  @override
  Future<Either<Failure, ReelsResponse>> call(int params) {
    return _repository.getFollowingReels(params);
  }
}
