import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';

import '../repositories/reels_repository.dart';

class AddReelReplyUseCase extends UseCase<AddCommentResponse, AddReelReplyParams> {
  final ReelsRepository _repository;

  AddReelReplyUseCase(this._repository);

  @override
  Future<Either<Failure, AddCommentResponse>> call(AddReelReplyParams params) {
    return _repository.addReply(params);
  }
}

class AddReelReplyParams{
  final String reelId;
    final String comment;
    final String? receiverComment;
    final String? parentCommentId;

  AddReelReplyParams({required this.reelId, required this.comment,required this.receiverComment, required this.parentCommentId});
  Map<String, dynamic> toJson() => {
    'comment': comment,
    if(receiverComment!=null)'receiverComment': receiverComment,
    if(parentCommentId!=null)'parentCommentId': parentCommentId
  };
}