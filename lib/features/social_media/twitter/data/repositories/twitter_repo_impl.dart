import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';

import '../../domain/repositories/twitter_repo.dart';
import '../datasources/twitter_remote_datasource.dart';

class TwitterRepoImpl implements TwitterRepo {
  final TwitterRemoteDataSource _remoteDataSource;
  TwitterRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed({required TwitterFeedParams params}) {
    return _remoteDataSource.getFeed(params: params);
  }

  @override
  Future<Either<Failure, TwitterPostEntity>> getTwitterPost({required String postId}) {
    return _remoteDataSource.getTwitterPost(postId: postId);
  }

  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required GetUserTweetsParams params}) {
    return _remoteDataSource.getUserPosts(params: params);
  }

  @override
  Future<Either<Failure, bool>> reactOnPost({required TwitterPostReactParams params}) {
    return _remoteDataSource.reactOnPost(params: params);
  }

  @override
  Future<Either<Failure, bool>> reactOnComment({required TwitterCommentReactParams params}) {
    return _remoteDataSource.reactOnComment(params: params);
  }

  @override
  Future<Either<Failure, bool>> sharePost({required String postId}) {
    return _remoteDataSource.sharePost( params: postId);
  }

  @override
  Future<Either<Failure, TwitterPostCommentEntity>> commentOnTwitterPost(
      {required TwitterPostCommentParams params}) {
    return _remoteDataSource.commentOnTwitterPost(params: params);
  }

  @override
  Future<Either<Failure, TwitterCommentReplyEntity>> replyOnComment(
      {required TwitterCommentReplyParams params}) {
    return _remoteDataSource.replyOnComment(params: params);
  }

  @override
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required PostCommentsParams params}) {
    return _remoteDataSource.getPostComments(params: params);
  }


  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) {
    return _remoteDataSource.deletePost(postId: postId);
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) {
    return _remoteDataSource.hidePost(postId: postId);
  }

  @override
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies({required PostCommentsParams params}) {
    return _remoteDataSource.getCommentReplies(params: params);
  }

  @override
  Future<Either<Failure, bool>> addReport({required TwitterReportParams params}) {
    return _remoteDataSource.addReport(params: params);
  }

  @override
  Future<Either<Failure, bool>> requestDocument({required TwitterDocumentationParams params}) {
    return _remoteDataSource.requestDocument(params: params);

  }




}
