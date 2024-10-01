import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/user_remote_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  const UserRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUser() {
    return _remoteDataSource.getUser();
  }

  // @override
  // Future<Either<Failure, WalletModel>> getWallet() {
  //   return _remoteDataSource.getWallet();
  // }
}
