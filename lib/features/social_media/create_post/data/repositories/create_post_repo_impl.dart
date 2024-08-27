import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/create_post/data/datasources/create_post_remote_datasource.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/place_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/friends-followers_usecase.dart';
import '../../domain/repositories/create_post_repo.dart';

class CreatePostRepoImpl implements CreatePostRepo {
  final CreatePostRemoteDataSource _remoteDataSource;
  CreatePostRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList() {
    return _remoteDataSource.getActivitiesList();
  }

  @override
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList() {
    return _remoteDataSource.getFeelingsList();
  }

  @override
  Future<Either<Failure, bool>> postData({required Map<String, dynamic> data}) {
    return _remoteDataSource.postData(data: data);
  }

  @override
  Future<Either<Failure, bool>> createTwitterPost(
      {required CreateTwitterPostParams params}) {
    return _remoteDataSource.createTwitterPost(params: params);
  }

  @override
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers({required FriendsFollowersParams params}) {
    return _remoteDataSource.getFriendsFollowers(params: params);
  }
  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({required FriendsFollowersParams params}) {
    return _remoteDataSource.getPlaces(params: params);
  }
}
