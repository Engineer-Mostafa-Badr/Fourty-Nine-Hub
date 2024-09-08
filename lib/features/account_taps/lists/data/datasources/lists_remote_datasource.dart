import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/lists/data/models/user_friend_model.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';

abstract class ListsRemoteDataSource {
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList({required TwitterFeedParams params});
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers({required TwitterFeedParams params});
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests({required TwitterFeedParams params});
  Future<Either<Failure, List<UserFriendEntity>>> getBlockedUsers({required TwitterFeedParams params});
}

class ListsRemoteDataSourceImpl implements ListsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  ListsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<UserFriendEntity >>> getBlockedUsers({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
        EndPoints.blockedUsersList(params));

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
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
        EndPoints.followersList(params));

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
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
        EndPoints.friendRequestsList(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['friendRequests'] as List)
          .map((e) => UserFriendModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList({required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(
        EndPoints.friendsList(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['friends'] as List)
          .map((e) => UserFriendModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }
}
