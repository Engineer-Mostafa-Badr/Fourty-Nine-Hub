import 'package:dartz/dartz.dart';
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

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<Either<Failure, UserTokensModel>> login(LoginParams loginParams);

  Future<Either<Failure, UserTokensModel>> socialLogin(SocialLoginParams params);

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
      (response) => Right(
        UserTokensModel.fromJson(
          response['data'],
        ),
      ),
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




  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user is null (i.e., the user canceled the sign-in)
      if (googleUser == null) {
        return Left(SocialLoginFailure('Google sign-in was canceled by the user.'));
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Return the signed-in user's credentials
      return Right(userCredential);
    } catch (e) {
      return Left(SocialLoginFailure('Failed to sign in with Google: $e'));
    }
  }


  @override
  Future<Either<Failure, UserTokensModel>> socialLogin(SocialLoginParams params) async {
    try {
      // Perform Google sign-in and get the user credentials
      final signInResult = await signInWithGoogle();

      // Handle the result
      return signInResult.fold(
            (failure) => Left(failure), // If the sign-in failed, return the failure
            (userCredential) async {
          // If sign-in succeeded, obtain the tokens (idToken and accessToken)
          final idToken = await userCredential.user?.getIdToken();
          final accessToken = await userCredential.user?.getIdTokenResult();

          // Prepare the social login data (you can include idToken and accessToken in the params)
          final data = {
            'idToken': idToken,
            'accessToken': accessToken?.token,
            // Add other necessary data for your backend here
            'deviceId': 'dfdfrrgtgt', // Replace with actual device ID if needed
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
}
