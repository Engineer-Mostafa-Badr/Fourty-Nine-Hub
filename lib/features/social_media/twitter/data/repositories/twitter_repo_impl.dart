import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';

import '../../domain/repositories/twitter_repo.dart';
import '../datasources/twitter_remote_datasource.dart';

class TwitterRepoImpl implements TwitterRepo {
  final TwitterRemoteDataSource _remoteDataSource;
  TwitterRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed({required TwitterFeedParams params}) {
    return _remoteDataSource.getFeed(params: params);
  }

  Future<Either<Failure, TwitterPostEntity>> getTwitterPost({required String postId}) {
    return _remoteDataSource.getTwitterPost(postId: postId);
  }

  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required String userId}) {
    return _remoteDataSource.getUserPosts(userId: userId);
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
  Future<Either<Failure, bool>> commentOnTwitterPost(
      {required PostCommentParams params}) {
    return _remoteDataSource.commentOnTwitterPost(params: params);
  }

  @override
  Future<Either<Failure, bool>> replyOnComment(
      {required TwitterCommentReplyParams params}) {
    return _remoteDataSource.replyOnComment(params: params);
  }

  @override
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required String postId}) {
    return _remoteDataSource.getPostComments(postId: postId);
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
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies({required String commentId}) {
    return _remoteDataSource.getCommentReplies(commentId: commentId);
  }




}
