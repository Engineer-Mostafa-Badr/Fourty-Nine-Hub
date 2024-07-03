import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/users_list_entity.dart';
import '../models/users_list_model.dart';

abstract class ListsRemoteDataSource {
  Future<Either<Failure, List<UsersListEntity>>> getFriendsList();
  Future<Either<Failure, List<UsersListEntity>>> getFollowers();
  Future<Either<Failure, List<UsersListEntity>>> getFreindRequests();
  Future<Either<Failure, List<UsersListEntity>>> getBlockedUsers();
}

class ListsRemoteDataSourceImpl implements ListsRemoteDataSource {
  final JsonParser _apiConsumer;
  ListsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<UsersListEntity>>> getBlockedUsers() async {
    final response = await _apiConsumer.get(Jsons.usersList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['items'] as List)
            .map((e) => UsersListModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<UsersListEntity>>> getFollowers() async {
    final response = await _apiConsumer.get(Jsons.usersList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['items'] as List)
            .map((e) => UsersListModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<UsersListEntity>>> getFreindRequests() async {
    final response = await _apiConsumer.get(Jsons.usersList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['items'] as List)
            .map((e) => UsersListModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<UsersListEntity>>> getFriendsList() async {
    final response = await _apiConsumer.get(Jsons.usersList);

    return response.fold((failure) {
      return Left(failure);
    },
        (data) => Right((data['data']['items'] as List)
            .map((e) => UsersListModel.fromJson(e))
            .toList()));
  }
}
