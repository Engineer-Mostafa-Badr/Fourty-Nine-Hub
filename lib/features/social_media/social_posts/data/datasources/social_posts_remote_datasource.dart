import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/suggest_user_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/suggest_user_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/suggest_friends_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../models/comment_model.dart';

abstract class SocialPostsRemoteDataSource {
  Future<Either<Failure, List<PostEntity>>> getFeed();
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required String userId});

  Future<Either<Failure, bool>> reactOnPost({required PostReactParams params});
  Future<Either<Failure, bool>> commentOnPost(
      {required PostCommentParams params});
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required String postId});

  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> friendRequest({required String userId});
  Future<Either<Failure, bool>> followRequest({required String userId});
  Future<Either<Failure, bool>> sendGreetMessage({required String userId});
  Future<Either<Failure, bool>> removeSuggestUser({required String userId});
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends({required SuggestedFriendsParams params});
}

class SocialPostsRemoteDataSourceImpl implements SocialPostsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  SocialPostsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<PostEntity>>> getFeed() async {
    final response = await _apiConsumer.get(EndPoints.getFeedPosts);

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
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
      {required String userId}) async {
    final response = await _apiConsumer.get(EndPoints.userPosts(userId));
    return response.fold(
        (l) => Left(l),
        (data) => Right(
            (data['data'] as List).map((e) => PostModel.fromJson(e)).toList()));
  }

  @override
  Future<Either<Failure, bool>> reactOnPost(
      {required PostReactParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.reactOnPost(params.postId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> commentOnPost(
      {required PostCommentParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.commentOnPost(params.postId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getPostComments(
      {required String postId}) async {
    final response = await _apiConsumer.get(EndPoints.getPostComments(postId));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) async {
    final response = await _apiConsumer.delete(EndPoints.deletePost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) async {
    final response = await _apiConsumer.put(EndPoints.hidePost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<SuggestUserEntity>>> suggestedFriends({required SuggestedFriendsParams params}) async{
    final response = await _apiConsumer.get(EndPoints.userSuggests(params));
    return response.fold(
            (l) => Left(l),
            (data) => Right((data['data'] as List)
            .map((e) => SuggestUserModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> friendRequest({required String userId}) async{
    final response = await _apiConsumer.post(EndPoints.friendRequest(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> followRequest({required String userId}) async{
    final response = await _apiConsumer.post(EndPoints.followRequest(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
  @override
  Future<Either<Failure, bool>> sendGreetMessage({required String userId}) async{
    final response = await _apiConsumer.post(EndPoints.greetMessage(userId),data: {
      "message":"Greet"
    });
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> removeSuggestUser({required String userId}) async{
    final response = await _apiConsumer.post(EndPoints.removeSuggestUser(userId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
