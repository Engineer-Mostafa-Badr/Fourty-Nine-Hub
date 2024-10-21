import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/followers_model.dart';

import '../repositories/stories_repository.dart';

class GetFollowersUseCase extends UseCase<ResponseModel, NoParams> {
  final StoriesRepository _repository;

  GetFollowersUseCase(this._repository);

  @override
  Future<Either<Failure, ResponseModel>> call(NoParams params) {
    return _repository.getFollowers();
  }
}
