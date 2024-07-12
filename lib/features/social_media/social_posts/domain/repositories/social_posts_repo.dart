import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/comment_entity.dart';
import '../entities/post_entity.dart';
import '../usecases/post_comment_usecase.dart';
import '../usecases/post_react_usecase.dart';

abstract class SocialPostsRepo {
  Future<Either<Failure, List<PostEntity>>> getFeed();
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required String userId});
  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params});
  Future<Either<Failure, bool>> commentOnPost(
      {required PostCommentParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required String postId});
  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
}
