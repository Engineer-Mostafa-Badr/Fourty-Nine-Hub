import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/activity_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/life_event_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/place_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/models/post_user_model.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/life_event_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/get_sub_activities_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../models/feeling_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList(PaginationParams params);
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList(PaginationParams params);
  Future<Either<Failure, List<ActivityEntity>>> getSubActivitiesList(GetSubActivitiesParams params);
  Future<Either<Failure, List<LifeEventEntity>>> getLifeEventCategories();
  Future<Either<Failure, List<LifeEventEntity>>> getLifeEventSubCategories(String id);
  Future<Either<Failure, bool>> postData({required Map<String, dynamic> data});
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers(
      {required FriendsFollowersParams params});
  Future<Either<Failure, List<PlaceEntity>>> getPlaces(
      {required FriendsFollowersParams params});
  Future<Either<Failure, bool>> createTwitterPost(
      {required CreateTwitterPostParams params});
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final JsonParser _jsonParser;
  final ApiConsumer _apiConsumer;
  CreatePostRemoteDataSourceImpl(this._jsonParser, this._apiConsumer);
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList(PaginationParams params) async {
    // final response = await _jsonParser.get(Jsons.activities);
    // return response.fold(
    //     (l) => Left(l),
    //         (data) => Right((data['data']['items'] as List)
    //         .map((e) => ActivityModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.activities(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['activities'] as List)
            .map((e) => ActivityModel.fromJson(e))
            .toList()));
  }
  @override
  Future<Either<Failure, List<ActivityEntity>>> getSubActivitiesList(GetSubActivitiesParams params) async {
    // final response = await _jsonParser.get(Jsons.activities);
    // return response.fold(
    //     (l) => Left(l),
    //         (data) => Right((data['data']['items'] as List)
    //         .map((e) => ActivityModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.subActivities(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['subActivities'] as List)
            .map((e) => ActivityModel.fromJson(e))
            .toList()));
  }
  @override
  Future<Either<Failure, List<LifeEventEntity>>> getLifeEventCategories() async {
    // final response = await _jsonParser.get(Jsons.activities);
    // return response.fold(
    //     (l) => Left(l),
    //         (data) => Right((data['data']['items'] as List)
    //         .map((e) => ActivityModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.getLifeEventsCategories);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['liveEventCategories'] as List)
            .map((e) => LifeEventModel.fromJson(e))
            .toList()));
  }
  @override
  Future<Either<Failure, List<LifeEventEntity>>> getLifeEventSubCategories(String id) async {
    // final response = await _jsonParser.get(Jsons.activities);
    // return response.fold(
    //     (l) => Left(l),
    //         (data) => Right((data['data']['items'] as List)
    //         .map((e) => ActivityModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.getLifeEventsSubCategories(id));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['liveEventTypes'] as List)
            .map((e) => LifeEventModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList(PaginationParams params) async {
    // final response = await _jsonParser.get(Jsons.feelings);
    // return response.fold(
    //     (l) => Left(l),
    //     (data) => Right((data['data']['items'] as List)
    //         .map((e) => FeelingModel.fromJson(e))
    //         .toList()));
    final response = await _apiConsumer.get(EndPoints.feelings(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['feelings'] as List)
            .map((e) => FeelingModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> postData(
      {required Map<String, dynamic> data}) async {
    print('say hi');
    final response = await _apiConsumer.post(EndPoints.createFacebookPost,
        data: data,
        // queryParameters: {'subCategory': '66b77e77bb35968b535dc944'}
    );
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
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers(
      {required FriendsFollowersParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getFriendsFollowers(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['users'] as List)
            .map((e) => PostUserModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces(
      {required FriendsFollowersParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getPlaces(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['results'] as List)
            .map((e) => PlaceModel.fromJson(e))
            .toList()));
  }
}
