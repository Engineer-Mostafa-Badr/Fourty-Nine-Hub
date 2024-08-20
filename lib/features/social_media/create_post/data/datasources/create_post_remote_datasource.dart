import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/activity_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/post_user_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/user_profile_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../models/feeling_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList();
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList();
  Future<Either<Failure, bool>> postData({required Map<String, dynamic> data});
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers({required FriendsFollowersParams params});
  Future<Either<Failure, bool>> createTwitterPost(
      {required CreateTwitterPostParams params});
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;
  CreatePostRemoteDataSourceImpl(this._jsonParser, this._apiConsumer);
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList() async {
    // final response = await _jsonParser.get(Jsons.activities);
    // return response.fold(
    //     (l) => Left(l),
    //         (data) => Right((data['data']['items'] as List)
    //         .map((e) => ActivityModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.activities);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => ActivityModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList() async {
    // final response = await _jsonParser.get(Jsons.feelings);
    // return response.fold(
    //     (l) => Left(l),
    //     (data) => Right((data['data']['items'] as List)
    //         .map((e) => FeelingModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.feelings);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => FeelingModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> postData(
      {required Map<String, dynamic> data}) async {
    print('say hi');
    final response =
        await _apiConsumer.post(EndPoints.createFacebookPost, data: data);
    return response.fold(
        (l) => Left(l), (data) => Right(data['status'] as bool));
  }

  @override
  Future<Either<Failure, bool>> createTwitterPost(
      {required CreateTwitterPostParams params}) async {
    final response =
        await _apiConsumer.post(EndPoints.createTwitterPost, data: {
      'content': params.content,
      'mediaIds': params.mediaIds.isEmpty ? [] : params.mediaIds
    });
    return response.fold((l) => Left(l),
        (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers({required FriendsFollowersParams params}) async{
    final response = await _apiConsumer.get(EndPoints.getFriendsFollowers(params));
    return response.fold(
            (l) => Left(l),
            (data) => Right((data['data']['users'] as List)
            .map((e) => PostUserModel.fromJson(e))
            .toList()));
  }
}
