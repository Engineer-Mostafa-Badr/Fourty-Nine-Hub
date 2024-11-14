import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';

import '../repositories/reels_repository.dart';
import 'package:fourtyninehub/features/social_media/reels/data/data_sources/reels_remote_data_source.dart';

class GetCommentsUseCase extends UseCase<GetCommentsResponse, CommentParams> {
  final ReelsRepository _repository;

  GetCommentsUseCase(this._repository);

  @override
  Future<Either<Failure, GetCommentsResponse>> call(CommentParams params) {
    return _repository.getComments(params);
  }
}
