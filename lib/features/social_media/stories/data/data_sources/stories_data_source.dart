import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../models/followers_model.dart';
import '../models/friends_stories_model.dart';
import '../models/muted_stories_model.dart';
import '../models/viewers_model.dart';
import '../../domain/use_case/update_privacy_use_case.dart';

import '../../domain/use_case/create_story_use_case.dart';

abstract class StoriesRemoteDataSource {
  Future<Either<Failure, bool>> makeViews(String id);
  Future<Either<Failure, bool>> deleteStory(String id);
  Future<Either<Failure, bool>> makeLike(String id);
  Future<Either<Failure, bool>> createStory(CreateStoryParams params);
  Future<Either<Failure, bool>> muteUserStories(String id);
  Future<Either<Failure, ViewersResponse>> getStoryViewers(String id);
  Future<Either<Failure, MutedStoriesResponse>> getMutedStories(
      PaginationParams params);
  Future<Either<Failure, ResponseModel>> getFollowers();
  Future<Either<Failure, StoriesResponse>> fetchStories(
      PaginationParams params);
  Future<Either<Failure, bool>> updatePrivacy(UpdateStoryPrivacyParams params);
}

class StoriesRemoteDataSourceImpl implements StoriesRemoteDataSource {
  final ApiConsumer _apiConsumer;

  StoriesRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> makeViews(String id) async {
    final response = await _apiConsumer.post(
      EndPoints.makeViews(id),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['status'],
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteStory(String id) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteStory(id),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['status'],
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> makeLike(String id) async {
    final response = await _apiConsumer.post(
      EndPoints.makeLike(id),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['status'],
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> createStory(CreateStoryParams params) async {
    final response =
        await _apiConsumer.post(EndPoints.createStory, data: {'text': params.text, 'color': params.color, 'fontFamily': params.fontFamily,});
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['status'],
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> muteUserStories(String id) async {
    final response = await _apiConsumer
        .post(EndPoints.muteUserStories, data: {"muteUser": id});
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['status'],
      ),
    );
  }

  @override
  Future<Either<Failure, MutedStoriesResponse>> getMutedStories(
      PaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getMutedStories(params),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        MutedStoriesResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, ViewersResponse>> getStoryViewers(String id) async {
    final response = await _apiConsumer.get(
      EndPoints.getStoryViewers(id),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ViewersResponse.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, ResponseModel>> getFollowers() async {
    final response = await _apiConsumer.get(
      EndPoints.getFollowers,
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        ResponseModel.fromJson(response),
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> updatePrivacy(
      UpdateStoryPrivacyParams params) async {
    final response =
        await _apiConsumer.put(EndPoints.updatePrivacy, data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        response['status'],
      ),
    );
  }

  @override
  Future<Either<Failure, StoriesResponse>> fetchStories(
      PaginationParams params) async {
    final response = await _apiConsumer.get(EndPoints.fetchStories(params),
        data: params.toJson());
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        StoriesResponse.fromJson(response),
      ),
    );
  }
}
