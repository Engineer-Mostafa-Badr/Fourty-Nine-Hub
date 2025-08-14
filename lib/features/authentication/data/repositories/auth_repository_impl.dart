import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/social_auth_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_with_phone_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_by_phone_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/send_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_profile_view_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_phone_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_questions_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../domain/entities/register_by_phone_entity.dart';
import '../../domain/entities/verify_otp_entity.dart';
import '../../domain/use_cases/change_password_use_case.dart';
import '../models/forget_password_questions_model.dart';

//enum: ['google', 'facebook', 'local', 'apple']

Future<String> _getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? 'unknown_ios_device';
  }

  return 'unknown_device';
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final SocialAuthService _socialAuthService;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._socialAuthService,
  );

  @override
  bool attachToken(UserTokensEntity? token) {
    _remoteDataSource.attachToken(token?.toModel());
    return true;
  }

  @override
  Future<Either<Failure, UserTokensEntity>> changePassword(
      ChangePasswordParams params) {
    return _remoteDataSource.changePassword(params);
  }

  @override
  Future<Either<Failure, void>> clearGuestState() async {
    return await _localDataSource.clearGuestState();
  }

  @override
  Future<Either<Failure, ChatEntity>> createAnonymousChat(
      CreateAnonymousChatParams params) {
    return _remoteDataSource.createAnonymousChat(params);
  }

  @override
  Future<Either<Failure, void>> createNewForgetPassword(
    CreateNewForgetParams params,
  ) {
    return _remoteDataSource.createNewForgetPassword(params);
  }

  @override
  Future<Either<Failure, ChatEntity>> createNormalChat(
      CreateNormalChatParams params) {
    return _remoteDataSource.createNormalChat(params);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getGuestData() async {
    return await _localDataSource.getGuestData();
  }

  @override
  Future<bool> getGuestState() async {
    final result = await _localDataSource.getGuestState();
    return result.fold((_) => false, (isGuest) => isGuest);
  }

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViews(
      GetProfileViewsParams params) {
    return _remoteDataSource.getProfileViews(params);
  }

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViewsByUserId(
      GetProfileViewsParams params) {
    return _remoteDataSource.getProfileViewsByUserId(params);
  }

  @override
  Future<Either<Failure, int>> getUnreadedChatsCounter() {
    return _remoteDataSource.getUnreadedChatsCounter();
  }

  @override
  Future<Either<Failure, UserTokensEntity?>> getUserTokens() {
    return _localDataSource.getUserTokens();
  }

  @override
  Future<Either<Failure, double>> getWelcomeGift() {
    return _remoteDataSource.getWelcomeGift();
  }

  @override
  Future<Either<Failure, UserTokensEntity>> login(LoginParams params) async {
    final result = await _remoteDataSource.login(params);

    return result.fold(
      (failure) => Left(failure),
      (token) {
        return Right(token);
      },
    );
  }

  @override
  Future<Either<Failure, UserTokensEntity>> loginWithPhone(
      LoginWithPhoneParams params) {
    return _remoteDataSource.loginWithPhone(params);
  }

  @override
  Future<Either<Failure, void>> migrateGuestData() async {
    final guestDataResult = await _localDataSource.getGuestData();

    return guestDataResult.fold(
      (failure) => Left(failure),
      (guestData) async {
        if (guestData != null && guestData.isNotEmpty) {
          await _uploadGuestDataToServer(guestData);
          await _localDataSource.clearGuestData();
        }
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams registerParams) {
    return _remoteDataSource.register(registerParams);
  }

  @override
  Future<Either<Failure, RegisterByPhoneEntity>> registerByPhone(
      RegisterByPhoneParams params) {
    return _remoteDataSource.registerByPhone(params);
  }

  @override
  Future<Either<Failure, void>> resendOTP(ResendOTPParams params) {
    return _remoteDataSource.resendOTP(params);
  }

  @override
  Future<Either<Failure, void>> saveGuestData(Map<String, dynamic> data) async {
    return await _localDataSource.saveGuestData(data);
  }

  @override
  Future<Either<Failure, void>> saveGuestState() async {
    return await _localDataSource.saveGuestState();
  }

  @override
  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens) {
    return _localDataSource.saveUserTokens(userTokens?.toModel());
  }

  @override
  Future<Either<Failure, void>> sendForgetPasswordOTP(
    SendForgetPasswordParams params,
  ) {
    return _remoteDataSource.sendForgetPasswordOTP(params);
  }

  @override
  Future<Either<Failure, ForgetPasswordQuestionsModel>>
      sendForgetPasswordQuestions(SendForgetPasswordParams params) {
    return _remoteDataSource.sendForgetPasswordQuestions(params);
  }

  @override
  Future<Either<Failure, UserTokensEntity>> signInWithApple() async {
    try {
      // Sign in with Firebase
      final userCredential = await _socialAuthService.signInWithApple();

      if (userCredential?.user == null) {
        return const Left(SocialLoginFailure('Apple sign-in failed'));
      }

      // Get tokens and send to backend
      final idToken = await userCredential!.user!.getIdToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final deviceId = await _getDeviceId();

      final params = SocialLoginParams(
        idToken: idToken!,
        fcmToken: fcmToken ?? '',
        deviceId: deviceId,
      );

      return await _remoteDataSource.socialLogin(params);
    } catch (e) {
      return Left(SocialLoginFailure('Apple sign-in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserTokensEntity>> signInWithFacebook() async {
    try {
      // Sign in with Firebase
      final userCredential = await _socialAuthService.signInWithFacebook();

      if (userCredential?.user == null) {
        return const Left(SocialLoginFailure('Facebook sign-in failed'));
      }

      // Get tokens and send to backend
      final idToken = await userCredential!.user!.getIdToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final deviceId = await _getDeviceId();

      final params = SocialLoginParams(
        idToken: idToken!,
        fcmToken: fcmToken ?? '',
        deviceId: deviceId,
      );

      return await _remoteDataSource.socialLogin(params);
    } catch (e) {
      return Left(SocialLoginFailure('Facebook sign-in failed: $e'));
    }
  }

  // @override
  // Future<Either<Failure, UserTokensEntity>> signInWithFacebook() async {
  //   try {
  // final LoginResult loginResult = await FacebookAuth.instance.login();

  // final OAuthCredential facebookAuthCredential =
  //     FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // final result = await FirebaseAuth.instance
  //     .signInWithCredential(facebookAuthCredential);
  // final tokenResult = await _remoteDataSource.socialLogin(
  //   await _loginWithCredentials(
  // GoogleAuthProvider.credential(
  //   accessToken: result.credential?.accessToken,
  //   idToken: await result.user?.getIdToken(),
  // ),
  // ),
  // );
  // return tokenResult.fold(
  //   (failure) => Left(failure),
  //   (token) => Right(token),
  // );
  //   } catch (e) {
  //     return Left(SocialLoginFailure(e));
  //   }
  // }

  @override
  Future<Either<Failure, UserTokensEntity>> signInWithGoogle() async {
    try {
      // Sign in with Firebase
      final userCredential = await _socialAuthService.signInWithGoogle();

      if (userCredential?.user == null) {
        return const Left(SocialLoginFailure('Google sign-in failed'));
      }

      // Get tokens and send to backend
      final idToken = await userCredential!.user!.getIdToken();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final deviceId = await _getDeviceId();

      final params = SocialLoginParams(
        idToken: idToken!,
        fcmToken: fcmToken ?? '',
        deviceId: deviceId,
      );

      return await _remoteDataSource.socialLogin(params);
    } catch (e) {
      return Left(SocialLoginFailure('Google sign-in failed: $e'));
    }
  }

  // @override
  // Future<Either<Failure, void>> signOut() {
  //   return _remoteDataSource.logout();
  // }
  @override
  Future<Either<Failure, void>> signOut() async {
    // إلغاء الـ notification listeners قبل الـ logout
    try {
      if (serviceLocator.isRegistered<FcmNotificationHelper>()) {
        final fcmHelper = serviceLocator<FcmNotificationHelper>();
        if (fcmHelper is FcmNotificationHelperImpl) {
          fcmHelper.dispose(); 
        }
      }
    } catch (e) {
      log('Error disposing FCM helper during logout: $e');
    }

    return _remoteDataSource.logout();
  }

  @override
  Future<Either<Failure, bool>> updateProfileView(
      UpdateProfileViewParams params) {
    return _remoteDataSource.updateProfileView(params);
  }

  @override
  Future<Either<Failure, bool>> updateUserBio(String bio) {
    return _remoteDataSource.updateUserBio(bio: bio);
  }

  @override
  Future<Either<Failure, bool>> updateUserName(String name) {
    return _remoteDataSource.updateUserName(name: name);
  }

  @override
  Future<Either<Failure, void>> verifyForgetPasswordOTP(
    VerifyForgetOTPParams params,
  ) {
    return _remoteDataSource.verifyForgetPasswordOTP(params);
  }

  @override
  Future<Either<Failure, VerifyOtpEntity>> verifyOTP(
    VerifyOTPParams verifyOTPParams,
  ) {
    return _remoteDataSource.verifyOTP(verifyOTPParams);
  }

  @override
  Future<Either<Failure, VerifyOtpEntity>> verifyPhoneOTP(
      VerifyPhoneOTPParams params) {
    return _remoteDataSource.verifyPhoneOTP(params);
  }

  @override
  Future<Either<Failure, String>> verifyQuestions(
      VerifyQuestionsParams params) {
    return _remoteDataSource.verifyQuestions(params);
  }

  Future<SocialLoginParams> _loginWithCredentials(
    OAuthCredential credential,
  ) async {
    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await user.user!.getIdToken();
    return SocialLoginParams(
      idToken: idToken!,
      deviceId: await _getDeviceId(),
      fcmToken: await FirebaseMessaging.instance.getToken() ?? '',
    );
  }

  Future<void> _uploadGuestDataToServer(Map<String, dynamic> data) async {
    // Implementation لنقل البيانات للسيرفر
    // مثال: رفع السلة، المفضلة، إلخ
  }
}
