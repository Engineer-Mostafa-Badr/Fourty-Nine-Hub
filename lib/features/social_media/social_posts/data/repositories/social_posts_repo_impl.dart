import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';

import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import '../../domain/repositories/social_posts_repo.dart';
import '../datasources/social_posts_remote_datasource.dart';

class SocialPostsRepoImpl implements SocialPostsRepo {
  final SocialPostsRemoteDataSource _remoteDataSource;
  SocialPostsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed() {
    return _remoteDataSource.getFeed();
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required String userId}) {
    return _remoteDataSource.getUserPosts(userId: userId);
  }

  @override
  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params}) {
    return _remoteDataSource.reactOnPost(params: params);
  }

  @override
  Future<Either<Failure, bool>> reactOnComment({required PostReactParams params}) {
    return _remoteDataSource.reactOnComment(params: params);
  }

  @override
  Future<Either<Failure, CommentEntity>> commentOnPost(
      {required PostCommentParams params}) {
    return _remoteDataSource.commentOnPost(params: params);
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required String postId}) {
    return _remoteDataSource.getPostComments(postId: postId);
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) {
    return _remoteDataSource.deletePost(postId: postId);
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) {
    return _remoteDataSource.hidePost(postId  : postId);
  }

  @override
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends({required SuggestedFriendsParams params}) {
    return _remoteDataSource.suggestedFriends(params: params);
  }

  @override
  Future<Either<Failure, bool>> friendRequest({required String userId}) {
    return _remoteDataSource.friendRequest(userId: userId);
  }
  @override
  Future<Either<Failure, bool>> followRequest({required String userId}) {
    return _remoteDataSource.followRequest(userId: userId);
  }
  @override
  Future<Either<Failure, bool>> sendGreetMessage({required String userId}) {
    return _remoteDataSource.sendGreetMessage(userId: userId);
  }
  @override
  Future<Either<Failure, bool>> removeSuggestUser({required String userId}) {
    return _remoteDataSource.removeSuggestUser(userId: userId);
  }


  @override
  Future<Either<Failure, bool>> sharePost({required String postId}) {
    return _remoteDataSource.sharePost( params: postId);
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostCommentReplies({required String commentId}) {
    return _remoteDataSource.getPostCommentReplies(commentId: commentId);
  }
  @override
  Future<Either<Failure, CommentEntity>> replyOnComment({required ReplyOnCommentParams params}) {
    return _remoteDataSource.replyOnComment(params: params);
  }
}
