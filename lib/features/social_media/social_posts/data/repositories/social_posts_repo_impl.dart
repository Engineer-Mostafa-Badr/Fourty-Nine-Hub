import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';

import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../domain/repositories/social_posts_repo.dart';
import '../datasources/social_posts_remote_datasource.dart';

class SocialPostsRepoImpl implements SocialPostsRepo {
  final SocialPostsRemoteDataSource _remoteDataSource;
  SocialPostsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getFeed(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getAdvertisement(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getAdvertisement(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required UserPostsParams params}) {
    return _remoteDataSource.getUserPosts(params: params);
  }

  @override
  Future<Either<Failure, bool>> acceptRejectFriendRequest({required AcceptRejectFriendRequestParams params}) {
    return _remoteDataSource.acceptRejectFriendRequest(params: params);
  }

  @override
  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params}) {
    return _remoteDataSource.reactOnPost(params: params);
  }

  @override
  Future<Either<Failure, bool>> reactOnComment(
      {required PostReactParams params}) {
    return _remoteDataSource.reactOnComment(params: params);
  }

  @override
  Future<Either<Failure, CommentEntity>> commentOnPost(
      {required PostCommentParams params}) {
    return _remoteDataSource.commentOnPost(params: params);
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required PostCommentsParams params}) {
    return _remoteDataSource.getPostComments(params: params);
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) {
    return _remoteDataSource.deletePost(postId: postId);
  }

  @override
  Future<Either<Failure, bool>> deleteComment({required String commentId}) {
    return _remoteDataSource.deleteComment(commentId: commentId);
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) {
    return _remoteDataSource.hidePost(postId: postId);
  }

  @override
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends(
      {required SuggestedFriendsParams params}) {
    return _remoteDataSource.suggestedFriends(params: params);
  }

  @override
  Future<Either<Failure, bool>> friendRequest({required String userId}) {
    return _remoteDataSource.friendRequest(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> removeFriendRequest({required String userId}) {
    return _remoteDataSource.removeFriendRequest(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> blockUser({required String userId}) {
    return _remoteDataSource.blockUser(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> followRequest({required String userId}) {
    return _remoteDataSource.followRequest(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> unFollow({required String userId}) {
    return _remoteDataSource.unFollow(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> sendGreetMessage(
      {required SendGreetMessageParams params}) {
    return _remoteDataSource.sendGreetMessage(params: params);
  }

  @override
  Future<Either<Failure, bool>> removeSuggestUser({required String userId}) {
    return _remoteDataSource.removeSuggestUser(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> sharePost({required String postId}) {
    return _remoteDataSource.sharePost(params: postId);
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostCommentReplies(
      {required PostCommentsParams params}) {
    return _remoteDataSource.getPostCommentReplies(params: params);
  }

  @override
  Future<Either<Failure, CommentEntity>> replyOnComment(
      {required ReplyOnCommentParams params}) {
    return _remoteDataSource.replyOnComment(params: params);
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getTweet(
      {required TwitterFeedParams params}) {
    return _remoteDataSource.getTweet(params: params);
  }

  @override
  Future<Either<Failure, PostEntity>> getPost({required String postId}) {
    return _remoteDataSource.getPost(postId: postId);
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
      {required String params}) {
    return _remoteDataSource.getUserProfile(userId: params);
  }

  @override
  Future<Either<Failure, bool>> editComment(
      {required PostCommentParams params}) {
    return _remoteDataSource.editComment(params: params);
  }

  @override
  Future<Either<Failure, bool>> deleteFriend({required String userId}) {
    return _remoteDataSource.deleteFriend(userId: userId);
  }
}
