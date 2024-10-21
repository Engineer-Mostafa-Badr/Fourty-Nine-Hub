import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';

import '../repositories/stories_repository.dart';

class FetchStoriesUseCase extends UseCase<StoriesResponse, PaginationParams> {
  final StoriesRepository _repository;

  FetchStoriesUseCase(this._repository);

  @override
  Future<Either<Failure, StoriesResponse>> call(PaginationParams params) {
    return _repository.fetchStories(params);
  }
}
