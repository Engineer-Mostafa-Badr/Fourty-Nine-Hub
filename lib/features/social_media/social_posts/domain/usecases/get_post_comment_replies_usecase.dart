import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetPostCommentRepliesUseCase extends UseCase<List<CommentEntity>, PostCommentsParams> {
  final SocialPostsRepo _repo;
  GetPostCommentRepliesUseCase(this._repo);
  @override
  Future<Either<Failure, List<CommentEntity>>> call(PostCommentsParams params) async {
    return await _repo.getPostCommentReplies(params: params);
  }
}
