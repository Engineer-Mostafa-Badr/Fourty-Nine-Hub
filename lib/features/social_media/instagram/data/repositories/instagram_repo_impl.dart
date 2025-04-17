import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_data_entiry.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/add_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/delete_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../domain/repositories/social_posts_repo.dart';
import '../datasources/instagram_remote_datasource.dart';

class InstagramRepoImpl implements InstagramRepo {
  final InstagramRemoteDataSource _remoteDataSource;
  InstagramRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getFeed(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserMedia(
      {required InstagramUserMediaParams params}) {
    return _remoteDataSource.getUserMedia(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getGlobalFeed(params: params);
  }

  @override
  Future<Either<Failure, ReelInstagramDataEntity>> getReels(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getReels(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getSavedReels(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params}) {
    return _remoteDataSource.getUserReels(params: params);
  }

  @override
  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(
      TwitterFeedParams params) {
    return _remoteDataSource.getAllFollowers(params);
  }

  @override
  Future<Either<Failure, List<FollowingEntity>>> getAllFollowing(
      TwitterFeedParams params) {
    return _remoteDataSource.getAllFollowing(params);
  }

  @override
  Future<Either<Failure, InstagramPostDataModel>> getPosts(
      PaginationParams params) {
    return _remoteDataSource.getPosts(params);
  }

  @override
  Future<Either<Failure, List<UserTagEntity>>> getUserTag(String username) {
    return _remoteDataSource.getUserTag(username);
  }

  @override
  Future<Either<Failure, CommentInstagramDataEntiry>> getComment(
      String postId) {
    return _remoteDataSource.getComment(postId);
  }

  @override
  Future<Either<Failure, bool>> addComment(AddCommentParams params) {
    return _remoteDataSource.addComment(params);
  }

  @override
  Future<Either<Failure, bool>> deleteComment(DeleteCommentParams params) {
    return _remoteDataSource.deleteComment(params);
  }
}
