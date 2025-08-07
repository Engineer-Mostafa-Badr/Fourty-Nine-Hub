import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/add_comments_model.dart';

import '../repositories/reels_repository.dart';

class AddReelCommentUseCase
    extends UseCase<AddCommentResponse, AddReelCommentParams> {
  final ReelsRepository _repository;

  AddReelCommentUseCase(this._repository);

  @override
  Future<Either<Failure, AddCommentResponse>> call(
      AddReelCommentParams params) {
    return _repository.addComment(params);
  }
}

class AddReelCommentParams {
  final String reelId;
  final String comment;

  AddReelCommentParams({required this.reelId, required this.comment});
  Map<String, dynamic> toJson() => {'comment': comment};
}
