import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/usecases/creat_twitter_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';

import '../../domain/repositories/create_post_repo.dart';
import '../datasources/create_post_remote_datasource.dart';

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
  Future<Either<Failure, TwitterPostEntity>> createTwitterPost(
      {required CreateTwitterPostParams params}) {
    return _remoteDataSource.createTwitterPost(params: params);
  }
}
