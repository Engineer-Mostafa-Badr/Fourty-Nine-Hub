import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/stories_repository.dart';

class MuteStoriesUseCase extends UseCase<bool, String> {
  final StoriesRepository _repository;

  MuteStoriesUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.muteUserStories(params);
  }
}
