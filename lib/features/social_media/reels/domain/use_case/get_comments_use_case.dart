import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';

import '../repositories/reels_repository.dart';

class GetCommentsUseCase extends UseCase<GetCommentsResponse, String> {
  final ReelsRepository _repository;

  GetCommentsUseCase(this._repository);

  @override
  Future<Either<Failure, GetCommentsResponse>> call(String params) {
    return _repository.getComments(params);
  }
}
