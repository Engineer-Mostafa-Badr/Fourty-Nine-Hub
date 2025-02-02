import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/resend_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/send_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/update_profile_view_usecase.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_forget_password_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/verify_otp_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_anonymous_chat_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/create_normal_chat_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/utils/shared_pref.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<Either<Failure, bool>> updateUserBio({
    required String bio,
  });

  Future<Either<Failure, bool>> updateUserName({
    required String name,
  });

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
      (response) async {
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
      EndPoints.resendVerificationOTP,
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

  @override
  Future<Either<Failure, bool>> updateUserBio({required String bio}) async {
    final result =
        await _apiConsumer.put(EndPoints.updateUserBio(), data: {'bio': bio});
    log(result.toString(), name: "updateUserBio");
    return result.fold((failure) {
      log(failure.toString(), name: "updateUserBio");
      return Left(failure);
    }, (response) {
      return Right(response['status']);
    });
  }

  @override
  Future<Either<Failure, bool>> updateUserName({required String name}) async {
    final result = await _apiConsumer.put(EndPoints.updateUserName(),
        data: {'firstName': name, 'lastName': ' '});
    log(result.toString(), name: "updateUserName");
    return result.fold((failure) {
      log(failure.toString(), name: "updateUserName");
      return Left(failure);
    }, (response) {
      return Right(response['status']);
    });
  }

  @override
  Future<Either<Failure, ChatEntity>> createNormalChat(
      CreateNormalChatParams params) async {
    final response = await _apiConsumer.post(EndPoints.createNormalChat(
      categoryId: params.categoryId,
      otherUserId: params.otherUserId,
    ));
    return response.fold((failure) => Left(failure),
        (data) => Right(ChatModel.fromJson(data['data']['chat'])));
  }

  @override
  Future<Either<Failure, ChatEntity>> createAnonymousChat(
      CreateAnonymousChatParams params) async {
    final response = await _apiConsumer
        .post(EndPoints.createAnonymousChat(params.otherUserId));

    return response.fold((failure) => Left(failure),
        (data) => Right(ChatModel.fromJson(data['data']['chat'])));
  }

  @override
  Future<Either<Failure, bool>> updateProfileView(
      UpdateProfileViewParams params) async {
    final response = await _apiConsumer
        .post(EndPoints.updateProfileview(params.userId), data: {
      'viewAction': params.isProfile
          ? UpdateProfileViewActionType.profile
          : UpdateProfileViewActionType.avatar
    });
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViews(
      GetProfileViewsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getProfileviews(
        params.isProfile
            ? UpdateProfileViewActionType.profile
            : UpdateProfileViewActionType.avatar,
      ),
    );
    return response.fold((failure) => Left(failure), (data) {
      List<GetProfileViewsEntity> profileViews = (data['data'] as List)
          .map((e) => GetProfileViewsEntity.fromJson(e))
          .toList();
      return Right(profileViews);
    });
  }

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViewsByUserId(
      GetProfileViewsParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getProfileviewsByUserId(
        userId: params.userId,
        viewAction: params.isProfile
            ? UpdateProfileViewActionType.profile
            : UpdateProfileViewActionType.avatar,
      ),
    );
    return response.fold((failure) => Left(failure), (data) {
      List<GetProfileViewsEntity> profileViews = (data['data']['views'] as List)
          .map((e) => GetProfileViewsEntity.fromJson(e))
          .toList();
      return Right(profileViews);
    });
  }

  @override
  Future<Either<Failure, int>> getUnreadedChatsCounter() async {
    final response = await _apiConsumer.get(
      EndPoints.getUnreadedChatsCounter(),
    );
    return response.fold((failure) => Left(failure), (data) {
      return Right(data['data']);
    });
  }
}
