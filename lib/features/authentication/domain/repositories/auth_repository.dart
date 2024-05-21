import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, UserTokensEntity>> login(LoginParams params);

  Future<Either<Failure, UserTokensEntity?>> getUserTokens();

  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens);

  bool attachToken(String? token);
}
