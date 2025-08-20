import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/get_comments_model.dart';

import '../repositories/reels_repository.dart';
import '../../data/data_sources/reels_remote_data_source.dart';

class GetCommentsUseCase extends UseCase<GetCommentsResponse, CommentParams> {
  final ReelsRepository _repository;

  GetCommentsUseCase(this._repository);

  @override
  Future<Either<Failure, GetCommentsResponse>> call(CommentParams params) {
    return _repository.getComments(params);
  }
}
