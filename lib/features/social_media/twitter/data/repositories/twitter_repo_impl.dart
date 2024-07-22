import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
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

  // @override
  // Future<Either<Failure, bool>> commentOnPost(
  //     {required PostCommentParams params}) {
  //   return _remoteDataSource.commentOnPost(params: params);
  // }

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




}
