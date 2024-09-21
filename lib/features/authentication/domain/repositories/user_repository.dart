import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  const UserRepository();

  Future<Either<Failure, UserEntity>> getUser();
}
