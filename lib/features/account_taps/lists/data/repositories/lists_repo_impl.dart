import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

import 'package:fourtyninehub/features/account_taps/lists/domain/entities/users_list_entity.dart';

import '../../domain/repositories/lists_repo.dart';
import '../datasources/lists_remote_datasource.dart';

class ListsRepoImpl implements ListsRepo {
  final ListsRemoteDataSource _remoteDataSource;
  ListsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<UserFriendEntity>>> getBlockedUsers() async {
    return await _remoteDataSource.getBlockedUsers();
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers() async {
    return await _remoteDataSource.getFollowers();
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests() async {
    return await _remoteDataSource.getFreindRequests();
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList() async {
    return await _remoteDataSource.getFriendsList();
  }
}
