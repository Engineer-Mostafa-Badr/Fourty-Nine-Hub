import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/lists/data/models/user_friend_model.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import '../../../../../core/error/failure.dart';

abstract class ListsRemoteDataSource {
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList();
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers();
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests();
  Future<Either<Failure, List<UserFriendEntity>>> getBlockedUsers();
}

class ListsRemoteDataSourceImpl implements ListsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  ListsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<UserFriendEntity >>> getBlockedUsers() async {
    final response = await _apiConsumer.get(
        EndPoints.blockedUsersList);

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => UserFriendModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers() async {
    final response = await _apiConsumer.get(
        EndPoints.followersList);

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['followers'] as List)
          .map((e) => UserFriendModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests() async {
    final response = await _apiConsumer.get(
        EndPoints.friendRequestsList);

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => UserFriendModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList() async {
    final response = await _apiConsumer.get(
        EndPoints.friendsList);

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => UserFriendModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }
}
