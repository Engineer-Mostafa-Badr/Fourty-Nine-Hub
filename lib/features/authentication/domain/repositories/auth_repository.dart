import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_profile_view_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

import '../use_cases/register_use_case.dart';
import '../use_cases/send_forget_password_otp_use_case.dart';
import '../use_cases/verify_forget_password_otp_use_case.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Failure, bool>> updateUserBio(String bio);
  Future<Either<Failure, bool>> updateUserName(String name);

  Future<Either<Failure, UserTokensEntity>> login(LoginParams params);
  Future<Either<Failure, UserTokensEntity>> signInWithGoogle();
  // Future<Either<Failure, UserTokensEntity>> signInWithFacebook();
  Future<Either<Failure, UserTokensEntity>> signInWithApple();
  Future<Either<Failure, void>> register(RegisterParams registerParams);
  Future<Either<Failure, UserTokensEntity>> verifyOTP(
      VerifyOTPParams verifyOTPParams);
  Future<Either<Failure, void>> resendOTP(ResendOTPParams params);
  Future<Either<Failure, void>> sendForgetPasswordOTP(
      SendForgetOTPParams params);
  Future<Either<Failure, void>> verifyForgetPasswordOTP(
      VerifyForgetOTPParams params);
  Future<Either<Failure, void>> createNewForgetPassword(
      CreateNewForgetParams params);

  Future<Either<Failure, UserTokensEntity?>> getUserTokens();

  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens);

  // Future<Either<Failure, bool>> saveUserId (UserTokensEntity? userTokens);
  Future<Either<Failure, double>> getWelcomeGift();
  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, ChatEntity>> createNormalChat(
      CreateNormalChatParams params);

  Future<Either<Failure, ChatEntity>> createAnonymousChat(
      CreateAnonymousChatParams params);
  Future<Either<Failure, bool>> updateProfileView(
      UpdateProfileViewParams params);
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViews(
      GetProfileViewsParams params);
      Future<Either<Failure, int>> getUnreadedChatsCounter();
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViewsByUserId(
      GetProfileViewsParams params);
  bool attachToken(UserTokensEntity? token);
}
