import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../entities/comment_entity.dart';
import '../entities/post_entity.dart';
import '../usecases/post_comment_usecase.dart';
import '../usecases/post_react_usecase.dart';

abstract class SocialPostsRepo {
  Future<Either<Failure, List<PostEntity>>> getFeed({required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getAdvertisement({required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getTweet({required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required String userId});
  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params});
  Future<Either<Failure, bool>> reactOnComment({required PostReactParams params});
  Future<Either<Failure, CommentEntity>> commentOnPost(
      {required PostCommentParams params});
  Future<Either<Failure, CommentEntity>> replyOnComment(
      {required ReplyOnCommentParams params});
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends(
      {required SuggestedFriendsParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required PostCommentsParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostCommentReplies(
      {required PostCommentsParams params});

  Future<Either<Failure, PostEntity>> getPost(
      {required String postId});
  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> deleteComment({required String commentId});
  Future<Either<Failure, bool>> friendRequest({required String userId});
  Future<Either<Failure, bool>> followRequest({required String userId});
  Future<Either<Failure, bool>> sendGreetMessage({required String userId});
  Future<Either<Failure, bool>> removeSuggestUser({required String userId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> sharePost({required String postId});
}
