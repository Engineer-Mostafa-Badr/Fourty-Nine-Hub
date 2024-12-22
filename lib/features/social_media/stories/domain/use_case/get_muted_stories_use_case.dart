import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/muted_stories_model.dart';

import '../repositories/stories_repository.dart';

class GetMutedStoriesUseCase
    extends UseCase<MutedStoriesResponse, PaginationParams> {
  final StoriesRepository _repository;

  GetMutedStoriesUseCase(this._repository);

  @override
  Future<Either<Failure, MutedStoriesResponse>> call(PaginationParams params) {
    return _repository.getMutedStories(params);
  }
}
