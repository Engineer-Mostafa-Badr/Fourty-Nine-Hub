import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';

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
