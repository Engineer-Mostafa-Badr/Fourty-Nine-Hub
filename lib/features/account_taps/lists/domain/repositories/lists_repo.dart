import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';

import '../../../../../core/error/failure.dart';
import '../entities/users_list_entity.dart';

abstract class ListsRepo {
  Future<Either<Failure, List<UserFriendEntity>>> getFriendsList();
  Future<Either<Failure, List<UserFriendEntity>>> getFollowers();
  Future<Either<Failure, List<UserFriendEntity>>> getFreindRequests();
  Future<Either<Failure, List<UserFriendEntity>>> getBlockedUsers();
}
