import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/viewers_model.dart';

import '../repositories/stories_repository.dart';

class GetStoryViewersUseCase extends UseCase<ViewersResponse, String> {
  final StoriesRepository _repository;

  GetStoryViewersUseCase(this._repository);

  @override
  Future<Either<Failure, ViewersResponse>> call(String params) {
    return _repository.getStoryViewers(params);
  }
}
