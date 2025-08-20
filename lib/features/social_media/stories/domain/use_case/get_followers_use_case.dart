import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/followers_model.dart';

import '../repositories/stories_repository.dart';

class GetFollowersUseCase extends UseCase<ResponseModel, NoParams> {
  final StoriesRepository _repository;

  GetFollowersUseCase(this._repository);

  @override
  Future<Either<Failure, ResponseModel>> call(NoParams params) {
    return _repository.getFollowers();
  }
}
