import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_with_phone_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_by_phone_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_profile_view_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_phone_otp_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

import '../entities/forget_password_questions_entity.dart';
import '../entities/register_by_phone_entity.dart';
import '../entities/session_entity.dart';
import '../entities/verify_otp_entity.dart';
import '../use_cases/change_password_use_case.dart';
import '../use_cases/register_use_case.dart';
import '../use_cases/send_forget_password_otp_use_case.dart';
import '../use_cases/verify_forget_password_otp_use_case.dart';
import '../use_cases/verify_questions_use_case.dart';

abstract class AuthRepository {
  const AuthRepository();

  bool attachToken(UserTokensEntity? token);

  Future<Either<Failure, UserTokensEntity>> changePassword(
      ChangePasswordParams params);

  Future<Either<Failure, void>> clearGuestState();

  Future<Either<Failure, ChatEntity>> createAnonymousChat(
      CreateAnonymousChatParams params);

  Future<Either<Failure, void>> createNewForgetPassword(
      CreateNewForgetParams params);

  Future<Either<Failure, ChatEntity>> createNormalChat(
      CreateNormalChatParams params);

  Future<Either<Failure, Map<String, dynamic>?>> getGuestData();

  Future<bool> getGuestState();

  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViews(
      GetProfileViewsParams params);

  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViewsByUserId(
      GetProfileViewsParams params);

  Future<Either<Failure, int>> getUnreadedChatsCounter();

  Future<Either<Failure, UserTokensEntity?>> getUserTokens();

  // Future<Either<Failure, bool>> saveUserId (UserTokensEntity? userTokens);
  Future<Either<Failure, double>> getWelcomeGift();

  Future<Either<Failure, UserTokensEntity>> login(LoginParams params);

  Future<Either<Failure, UserTokensEntity>> loginWithPhone(
      LoginWithPhoneParams params);

  Future<Either<Failure, void>> migrateGuestData();

  Future<Either<Failure, void>> register(RegisterParams registerParams);

  Future<Either<Failure, RegisterByPhoneEntity>> registerByPhone(
      RegisterByPhoneParams params);

  Future<Either<Failure, void>> resendOTP(ResendOTPParams params);

  Future<Either<Failure, void>> saveGuestData(Map<String, dynamic> data);

  Future<Either<Failure, void>> saveGuestState();

  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens);

  Future<Either<Failure, void>> sendForgetPasswordOTP(
      SendForgetPasswordParams params);

  Future<Either<Failure, ForgetPasswordQuestionsEntity>>
      sendForgetPasswordQuestions(SendForgetPasswordParams params);
      
  //! Social Login
  Future<Either<Failure, UserTokensEntity>> signInWithApple();

  Future<Either<Failure, UserTokensEntity>> signInWithFacebook();

  Future<Either<Failure, UserTokensEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signOut({String? deviceId, String? refreshToken});

  Future<Either<Failure, bool>> updateProfileView(
      UpdateProfileViewParams params);
  Future<Either<Failure, bool>> updateUserBio(String bio);
  Future<Either<Failure, bool>> updateUserName(String name);
  Future<Either<Failure, void>> verifyForgetPasswordOTP(
      VerifyForgetOTPParams params);
  Future<Either<Failure, VerifyOtpEntity>> verifyOTP(
      VerifyOTPParams verifyOTPParams);
  Future<Either<Failure, VerifyOtpEntity>> verifyPhoneOTP(
      VerifyPhoneOTPParams params);
  Future<Either<Failure, String>> verifyQuestions(VerifyQuestionsParams params);

  Future<Either<Failure, void>> signOutFromAllDevices();

  Future<Either<Failure, List<SessionEntity>>> getAllSessions();
}