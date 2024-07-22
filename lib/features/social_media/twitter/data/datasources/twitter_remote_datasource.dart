import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_comment_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/data/models/twitter_post_model.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

import '../../../../../core/error/failure.dart';

abstract class TwitterRemoteDataSource {
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed({required TwitterFeedParams params});
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required String userId});

  Future<Either<Failure, bool>> reactOnPost({required  params});
  Future<Either<Failure, bool>> reactOnComment({required  params});
  Future<Either<Failure, bool>> sharePost({required  params});
  Future<Either<Failure, bool>> commentOnPost(
      {required PostCommentParams params});
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required String postId});

  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
}

class TwitterRemoteDataSourceImpl implements TwitterRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TwitterRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get("${EndPoints.getTwitterFeedPosts}?page=${params.page}&limit=${params.limit}");

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => TwitterPostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required String userId}) async {
    final response = await _apiConsumer.get(EndPoints.userPosts(userId));
    return response.fold(
        (l) => Left(l),
        (data) => Right(
            (data['data'] as List).map((e) => TwitterPostModel.fromJson(e)).toList()));
  }

  @override
  Future<Either<Failure, bool>> reactOnPost(
      {required  params}) async {
    final response = await _apiConsumer
        .post(EndPoints.reactOnTwitterPost(params.postId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> reactOnComment(
      {required  params}) async {
    final response = await _apiConsumer
        .post(EndPoints.reactOnTwitterComment(params.commentId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> sharePost({required params}) async{
    final response = await _apiConsumer
        .post(EndPoints.shareTwitterPost(params));
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
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required String postId}) async {
    final response = await _apiConsumer.get(EndPoints.getTwitterPostComments(postId));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => TwitterPostCommentModel.fromJson(e))
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


}
