import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/suggest_user_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/user_profile_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/send_greet_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../models/comment_model.dart';

abstract class SocialPostsRemoteDataSource {
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getTweet(
      {required TwitterFeedParams params});
  Future<Either<Failure, PostEntity>> getPost({required String postId});
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
      {required String userId});
  Future<Either<Failure, List<PostEntity>>> getAdvertisement(
      {required TwitterFeedParams params});
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required UserPostsParams params});

  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params});
  Future<Either<Failure, bool>> reactOnComment(
      {required PostReactParams params});
  Future<Either<Failure, CommentEntity>> replyOnComment(
      {required ReplyOnCommentParams params});

  Future<Either<Failure, bool>> editComment(
      {required PostCommentParams params});
  Future<Either<Failure, CommentEntity>> commentOnPost(
      {required PostCommentParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required PostCommentsParams params});

  Future<Either<Failure, List<CommentEntity>>> getPostCommentReplies(
      {required PostCommentsParams params});

  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> deleteComment({required String commentId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> friendRequest({required String userId});
  Future<Either<Failure, bool>> removeFriendRequest({required String userId});
  Future<Either<Failure, bool>> blockUser({required String userId});
  Future<Either<Failure, bool>> followRequest({required String userId});
  Future<Either<Failure, bool>> unFollow({required String userId});
  Future<Either<Failure, bool>> sendGreetMessage({required SendGreetMessageParams params});
  Future<Either<Failure, bool>> removeSuggestUser({required String userId});
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends(
      {required SuggestedFriendsParams params});
  Future<Either<Failure, bool>> sharePost({required params});
}

class SocialPostsRemoteDataSourceImpl implements SocialPostsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SocialPostsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getFeedPosts(params),
        data: {'subCategory': '66b77e77bb35968b535dc944'});

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getAdvertisement(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getAdvertisement(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['advertises'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, PostEntity>> getPost({required String postId}) async {
    final response = await _apiConsumer.get(EndPoints.deletePost(postId));
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(PostModel.fromJson(data['data'][0]));
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required UserPostsParams params}) async {
    final response = await _apiConsumer.get(
      EndPoints.userPosts(params),
    );
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['posts'] as List)
            .map((e) => PostModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> reactOnPost(
      {required PostReactParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.reactOnPost(params.postId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> reactOnComment(
      {required PostReactParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.reactOnComment(params.postId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, CommentEntity>> commentOnPost(
      {required PostCommentParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.commentOnPost(params.postId), data: params.toJson());
    return response.fold(
        (l) => Left(l), (data) => Right(CommentModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required PostCommentsParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getPostComments(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['comments'] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostCommentReplies(
      {required PostCommentsParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getPostCommentReplies(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['replies'] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) async {
    final response = await _apiConsumer.delete(EndPoints.deletePost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      {required String commentId}) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteComment(commentId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) async {
    final response = await _apiConsumer.put(EndPoints.hidePost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends(
      {required SuggestedFriendsParams params}) async {
    final response = await _apiConsumer.get(EndPoints.userSuggests(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => SuggestUserModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> friendRequest({required String userId}) async {
    final response = await _apiConsumer.post(EndPoints.friendRequest(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> removeFriendRequest(
      {required String userId}) async {
    final response =
        await _apiConsumer.delete(EndPoints.removeFriendRequest(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> blockUser({required String userId}) async {
    final response = await _apiConsumer.put(EndPoints.blocUser(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> followRequest({required String userId}) async {
    final response = await _apiConsumer.post(EndPoints.followRequest(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> unFollow({required String userId}) async {
    final response = await _apiConsumer.delete(EndPoints.removeFollow(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> sendGreetMessage(
      {required SendGreetMessageParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.greetMessage(params.userId), data: {"message": params.message});
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> removeSuggestUser(
      {required String userId}) async {
    final response =
        await _apiConsumer.post(EndPoints.removeSuggestUser(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> sharePost({required params}) async {
    final response =
        await _apiConsumer.post(EndPoints.shareFacebookPost(params));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, CommentEntity>> replyOnComment(
      {required ReplyOnCommentParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.commentOnPost(params.postId), data: params.toJson());
    return response.fold(
        (l) => Left(l), (data) => Right(CommentModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getTweet(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
        "${EndPoints.getTwitterFeedPosts}?page=${params.page}&limit=${params.limit}");

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
      {required String userId}) async {
    final response = await _apiConsumer.get(
      EndPoints.getUserProfile(userId),
    );
    return response.fold((l) => Left(l),
        (data) => Right(UserProfileModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> editComment(
      {required PostCommentParams params}) async {
    final response = await _apiConsumer
        .put(EndPoints.editComment(params), data: {'content': params.content});
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
