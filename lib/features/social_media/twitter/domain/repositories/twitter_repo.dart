import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../entities/twitter_post_entity.dart';
import '../usecases/post_react_usecase.dart';

abstract class TwitterRepo {
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed({required TwitterFeedParams params});
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required String userId});
  Future<Either<Failure, bool>> reactOnPost({required TwitterPostReactParams params});
  Future<Either<Failure, bool>> sharePost({required String postId});
  Future<Either<Failure, bool>> reactOnComment({required TwitterCommentReactParams params});
  // Future<Either<Failure, bool>> commentOnPost(
  //     {required PostCommentParams params});
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required String postId});
  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
}
