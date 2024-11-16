import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/send_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/utils/shared_pref.dart';
import '../../../../../main.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<Either<Failure, UserTokensModel>> login(LoginParams loginParams);

  Future<Either<Failure, UserTokensModel>> socialLogin(
      SocialLoginParams params);

  Future<Either<Failure, void>> register(RegisterParams registerParams);

  Future<Either<Failure, UserTokensModel>> verifyOTP(
    VerifyOTPParams verifyOTPParams,
  );

  Future<Either<Failure, void>> resendOTP(
    ResendOTPParams params,
  );

  Future<Either<Failure, void>> sendForgetPasswordOTP(
    SendForgetOTPParams params,
  );

  Future<Either<Failure, void>> verifyForgetPasswordOTP(
    VerifyForgetOTPParams params,
  );

  Future<Either<Failure, void>> createNewForgetPassword(
    CreateNewForgetParams params,
  );

  Future<Either<Failure, double>> getWelcomeGift();

  void attachToken(UserTokensModel? token);

  Future<Either<Failure, void>> logout();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiConsumer _apiConsumer;

  const AuthRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, UserTokensModel>> login(
    LoginParams loginParams,
  ) async {
    final result = await _apiConsumer.post(
      EndPoints.login,
      data: await loginParams.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response)async {
        _apiConsumer.attachToken(UserTokensModel.fromJson(
          response['data'],
        ));


        // await registerSocket();
        return Right(
        UserTokensModel.fromJson(
          response['data'],
        ),
      );
      },
    );
  }

  @override
  Future<Either<Failure, void>> register(
    RegisterParams registerParams,
  ) async {
    final result = await _apiConsumer.post(
      EndPoints.register,
      data: await registerParams.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, UserTokensModel>> verifyOTP(
    VerifyOTPParams verifyOTPParams,
  ) async {
    final result = await _apiConsumer.post(
      EndPoints.verifyOTP,
      data: verifyOTPParams.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        return Right(UserTokensModel.fromJson(
          response['data'],
        ));
      },
    );
  }

  @override
  void attachToken(UserTokensModel? token) {
    _apiConsumer.attachToken(token);
  }

  @override
  Future<Either<Failure, double>> getWelcomeGift() async {
    final result = await _apiConsumer.get(
      EndPoints.getWelcomeGift,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        double.parse(response['gift'].toString()),
      ),
    );
  }

  Future<Either<Failure, UserCredential>> signInWithGoogle({
    required String idToken,
  }) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user is null (i.e., the user canceled the sign-in)
      if (googleUser == null) {
        return const Left(
            SocialLoginFailure('Google sign-in was canceled by the user.'));
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user's credentials
      return Right(userCredential);
    } catch (e) {
      return Left(SocialLoginFailure('Failed to sign in with Google: $e'));
    }
  }

  Future<String?> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android device ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // iOS device ID
    }
    return 'unknown_device';
  }

  @override
  Future<Either<Failure, UserTokensModel>> socialLogin(
      SocialLoginParams params) async {
    try {
      // Perform Google sign-in and get the user credentials
      final signInResult = await signInWithGoogle(idToken: params.idToken);

      // Handle the result
      return signInResult.fold(
        (failure) => Left(failure),
        // If the sign-in failed, return the failure
        (userCredential) async {
          // If sign-in succeeded, obtain the tokens (idToken and accessToken)
          final idToken = await userCredential.user?.getIdToken();
          final accessToken = await userCredential.user?.getIdTokenResult();

          // Get the device ID
          final deviceId = await _getDeviceId();

          // Prepare the social login data (including idToken, fcm, and deviceId)
          final data = {
            'idToken': idToken,
            'fcm': accessToken?.token, // Use the FCM token if available
            'deviceId': deviceId, // Use the actual device ID
          };

          // Call the API for social login
          final result = await _apiConsumer.post(
            EndPoints.socialLogin,
            data: data,
          );

          // Handle the API response
          return result.fold(
            (failure) => Left(failure),
            (response) {
              final userData = response['data'];
              return Right(UserTokensModel.fromJson(userData));
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Social login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOTP(ResendOTPParams params) async {
    final result = await _apiConsumer.put(
      EndPoints.resendOTP,
      data: params.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> sendForgetPasswordOTP(
    SendForgetOTPParams params,
  ) async {
    final result = await _apiConsumer.post(
      EndPoints.sendForgetPasswordOTP,
      data: params.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> verifyForgetPasswordOTP(
    VerifyForgetOTPParams params,
  ) async {
    final result = await _apiConsumer.post(
      EndPoints.verifyForgetPasswordOTP,
      data: params.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> createNewForgetPassword(
    CreateNewForgetParams params,
  ) async {
    final result = await _apiConsumer.put(
      EndPoints.createNewForgetPassword,
      data: params.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    var result = await _apiConsumer.post(EndPoints.logout);
    return result.fold((l) => Left(l), (r) async {
      await CacheManager.deleteAllTokens();
      _apiConsumer.removeTokenFromHeader();
      // await registerSocket();

      return Right(r);
    });
  }
}
