import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/friends_stories_model.dart';

import '../repositories/stories_repository.dart';

class FetchStoriesUseCase extends UseCase<StoriesResponse, PaginationParams> {
  final StoriesRepository _repository;

  FetchStoriesUseCase(this._repository);

  @override
  Future<Either<Failure, StoriesResponse>> call(PaginationParams params) {
    return _repository.fetchStories(params);
  }
}
