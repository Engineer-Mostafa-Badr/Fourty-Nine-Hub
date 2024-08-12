import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../entities/twitter_post_entity.dart';
import '../usecases/post_react_usecase.dart';

abstract class TwitterRepo {
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, TwitterPostEntity>> getTwitterPost(
      {required String postId});
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required GetUserTweetsParams params});
  Future<Either<Failure, bool>> reactOnPost(
      {required TwitterPostReactParams params});
  Future<Either<Failure, bool>> sharePost({required String postId});
  Future<Either<Failure, bool>> reactOnComment(
      {required TwitterCommentReactParams params});
  Future<Either<Failure, TwitterPostCommentEntity>> commentOnTwitterPost(
      {required PostCommentParams params});
  Future<Either<Failure, TwitterCommentReplyEntity>> replyOnComment(
      {required TwitterCommentReplyParams params});
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required String postId});
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies(
      {required String commentId});
  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> addReport(
      {required TwitterReportParams params});
  Future<Either<Failure, bool>> requestDocument(
      {required TwitterDocumentationParams params});
}
