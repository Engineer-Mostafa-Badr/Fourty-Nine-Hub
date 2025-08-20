import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/viewers_model.dart';

import '../repositories/stories_repository.dart';

class GetStoryViewersUseCase extends UseCase<ViewersResponse, String> {
  final StoriesRepository _repository;

  GetStoryViewersUseCase(this._repository);

  @override
  Future<Either<Failure, ViewersResponse>> call(String params) {
    return _repository.getStoryViewers(params);
  }
}
