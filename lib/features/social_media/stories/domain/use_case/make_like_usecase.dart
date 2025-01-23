import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/stories_repository.dart';

class MakeLikeUseCase extends UseCase<bool, String> {
  final StoriesRepository _repository;

  MakeLikeUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.makeLike(params);
  }
}
