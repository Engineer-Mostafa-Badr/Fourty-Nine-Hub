import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/account_taps/lists/domain/entities/users_list_entity.dart';

import '../../domain/repositories/lists_repo.dart';
import '../datasources/lists_remote_datasource.dart';

class ListsRepoImpl implements ListsRepo {
  final ListsRemoteDataSource _remoteDataSource;
  ListsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<UsersListEntity>>> getBlockedUsers() async {
    return await _remoteDataSource.getBlockedUsers();
  }

  @override
  Future<Either<Failure, List<UsersListEntity>>> getFollowers() async {
    return await _remoteDataSource.getFollowers();
  }

  @override
  Future<Either<Failure, List<UsersListEntity>>> getFreindRequests() async {
    return await _remoteDataSource.getFreindRequests();
  }

  @override
  Future<Either<Failure, List<UsersListEntity>>> getFriendsList() async {
    return await _remoteDataSource.getFriendsList();
  }
}
