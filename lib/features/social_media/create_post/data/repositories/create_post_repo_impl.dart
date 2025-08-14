import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../datasources/create_post_remote_datasource.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/life_event_entity.dart';
import '../../domain/entities/feeling_entity.dart';
import '../../domain/entities/place_entity.dart';
import '../../domain/entities/post_user_entity.dart';
import '../../domain/usecases/creat_twitter_usecase.dart';
import '../../domain/usecases/friends-followers_usecase.dart';
import '../../domain/repositories/create_post_repo.dart';
import '../../domain/usecases/get_sub_activities_usecase.dart';

class CreatePostRepoImpl implements CreatePostRepo {
  final CreatePostRemoteDataSource _remoteDataSource;
  CreatePostRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesList(PaginationParams params) {
    return _remoteDataSource.getActivitiesList(params);
  }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getSubActivitiesList(GetSubActivitiesParams params) {
    return _remoteDataSource.getSubActivitiesList(params);
  }

 @override
  Future<Either<Failure, List<LifeEventEntity>>> getLifeEventCategories() {
    return _remoteDataSource.getLifeEventCategories();
  }

 @override
  Future<Either<Failure, List<LifeEventEntity>>> getLifeEventSubCategories(String id) {
    return _remoteDataSource.getLifeEventSubCategories(id);
  }

  @override
  Future<Either<Failure, List<FeelingEntity>>> getFeelingsList(PaginationParams params) {
    return _remoteDataSource.getFeelingsList(params);
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
  Future<Either<Failure, List<PostUserEntity>>> getFriendsFollowers(
      {required FriendsFollowersParams params}) {
    return _remoteDataSource.getFriendsFollowers(params: params);
  }

  @override
  Future<Either<Failure, List<PlaceEntity>>> getPlaces(
      {required FriendsFollowersParams params}) {
    return _remoteDataSource.getPlaces(params: params);
  }
}
