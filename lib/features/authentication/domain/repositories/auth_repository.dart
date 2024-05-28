import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';

import '../use_cases/register_use_case.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, UserTokensEntity>> login(LoginParams params);
  Future<Either<Failure, void>> register(RegisterParams registerParams);
  Future<Either<Failure, void>> verifyOTP(VerifyOTPParams verifyOTPParams);

  Future<Either<Failure, UserTokensEntity?>> getUserTokens();

  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens);
  Future<Either<Failure, double>> getWelcomeGift();

  bool attachToken(UserTokensEntity? token);
}
