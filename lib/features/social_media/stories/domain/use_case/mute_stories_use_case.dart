import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';

import '../repositories/stories_repository.dart';

class MuteStoriesUseCase extends UseCase<bool, String> {
  final StoriesRepository _repository;

  MuteStoriesUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.muteUserStories(params);
  }
}
