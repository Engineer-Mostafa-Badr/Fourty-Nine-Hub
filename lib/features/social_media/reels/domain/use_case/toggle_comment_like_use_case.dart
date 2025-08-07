import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/reels_repository.dart';

class ToggleCommentLikeUseCase extends UseCase<String, String> {
  final ReelsRepository _repository;

  ToggleCommentLikeUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String params) {
    return _repository.toggleCommentLike(params);
  }
}
