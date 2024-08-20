import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/models/wallet_model.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  const UserRepository();

  Future<Either<Failure, UserEntity>> getUser();
}
