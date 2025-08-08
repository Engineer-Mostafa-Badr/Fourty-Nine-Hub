import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/muted_stories_model.dart';

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
