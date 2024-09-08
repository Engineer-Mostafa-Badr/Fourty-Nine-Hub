import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/comment_entity.dart';
import '../entities/post_entity.dart';
import '../usecases/post_comment_usecase.dart';
import '../usecases/post_react_usecase.dart';

abstract class SocialPostsRepo {
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getAdvertisement(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getTweet(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required UserPostsParams params});
  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params});
  Future<Either<Failure, bool>> reactOnComment(
      {required PostReactParams params});
  Future<Either<Failure, CommentEntity>> commentOnPost(
      {required PostCommentParams params});
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
      {required String params});
  Future<Either<Failure, bool>> viewProfile(
      {required String params});
  Future<Either<Failure, CommentEntity>> replyOnComment(
      {required ReplyOnCommentParams params});
  Future<Either<Failure, bool>> editComment(
      {required PostCommentParams params});
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends(
      {required SuggestedFriendsParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required PostCommentsParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostCommentReplies(
      {required PostCommentsParams params});

  Future<Either<Failure, PostEntity>> getPost({required String postId});
  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> deleteFriend({required String userId});
  Future<Either<Failure, bool>> acceptRejectFriendRequest({required AcceptRejectFriendRequestParams params});
  Future<Either<Failure, bool>> deleteComment({required String commentId});
  Future<Either<Failure, bool>> friendRequest({required String userId});
  Future<Either<Failure, bool>> removeFriendRequest({required String userId});
  Future<Either<Failure, bool>> blockUser({required String userId});
  Future<Either<Failure, bool>> followRequest({required String userId});
  Future<Either<Failure, bool>> unFollow({required String userId});
  Future<Either<Failure, bool>> sendGreetMessage(
      {required SendGreetMessageParams params});
  Future<Either<Failure, bool>> removeSuggestUser({required String userId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> sharePost({required String postId});
}
