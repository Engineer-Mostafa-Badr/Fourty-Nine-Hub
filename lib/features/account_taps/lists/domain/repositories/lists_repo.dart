import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/users_list_entity.dart';

abstract class ListsRepo {
  Future<Either<Failure, List<UsersListEntity>>> getFriendsList();
  Future<Either<Failure, List<UsersListEntity>>> getFollowers();
  Future<Either<Failure, List<UsersListEntity>>> getFreindRequests();
  Future<Either<Failure, List<UsersListEntity>>> getBlockedUsers();
}
