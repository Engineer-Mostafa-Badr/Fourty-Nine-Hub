import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';

import '../../domain/repositories/lists_repo.dart';
import '../datasources/lists_remote_datasource.dart';

class ListsRepoImpl implements ListsRepo {
  final ListsRemoteDataSource _remoteDataSource;
  ListsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<UserFriendEntity>>> getBlockedUsers(
      {required TwitterFeedParams params}) async {
    return await _remoteDataSource.getBlockedUsers(params: params);
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers(
      {required TwitterFeedParams params}) async {
    return await _remoteDataSource.getFollowers(params: params);
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests(
      {required TwitterFeedParams params}) async {
    return await _remoteDataSource.getFreindRequests(params: params);
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList(
      {required TwitterFeedParams params}) async {
    return await _remoteDataSource.getFriendsList(params: params);
  }
}
