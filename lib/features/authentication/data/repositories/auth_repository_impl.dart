import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, UserTokensEntity>> login(LoginParams params) {
    return _remoteDataSource.login(params);
  }

  @override
  Future<Either<Failure, UserTokensEntity?>> getUserTokens() {
    return _localDataSource.getUserTokens();
  }

  @override
  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens) {
    return _localDataSource.saveUserTokens(userTokens?.toModel());
  }

  @override
  bool attachToken(String? token) {
    _remoteDataSource.attachToken(token);
    return true;
  }
}
