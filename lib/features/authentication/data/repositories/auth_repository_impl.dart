import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/local_data_source/auth_local_data_source.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
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
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

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
  Future<Either<Failure, UserTokensEntity?>> getUserTokens() {
    return _localDataSource.getUserTokens();
  }

  @override
  Future<Either<Failure, bool>> saveUserTokens(UserTokensEntity? userTokens) {
    return _localDataSource.saveUserTokens(userTokens?.toModel());
  }

  @override
  bool attachToken(UserTokensEntity? token) {
    _remoteDataSource.attachToken(token?.toModel());
    return true;
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams registerParams) {
    return _remoteDataSource.register(registerParams);
  }

  @override
  Future<Either<Failure, UserTokensEntity>> verifyOTP(
    VerifyOTPParams verifyOTPParams,
  ) {
    return _remoteDataSource.verifyOTP(verifyOTPParams);
  }

  @override
  Future<Either<Failure, double>> getWelcomeGift() {
    return _remoteDataSource.getWelcomeGift();
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
      final result = await GoogleSignIn().signIn();

      if (result != null) {
        final googleAuth = await result.authentication;
        final tokenResult = await _remoteDataSource.socialLogin(
          await _loginWithCredentials(
            GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            ),
          ),
        );
        return tokenResult.fold(
          (failure) => Left(failure),
          (token) => Right(token),
        );
      }
      return const Left(SocialLoginFailure('Google sign in failed'));
    } catch (e) {
      return Left(SocialLoginFailure(e));
    }
  }

  Future<SocialLoginParams> _loginWithCredentials(
    OAuthCredential credential,
  ) async {
    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    final idToken = await user.user!.getIdToken();
    return SocialLoginParams(idToken!);
  }

  @override
  Future<Either<Failure, void>> resendOTP(ResendOTPParams params) {
    return _remoteDataSource.resendOTP(params);
  }

  @override
  Future<Either<Failure, UserTokensEntity>> signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> sendForgetPasswordOTP(
    SendForgetOTPParams params,
  ) {
    return _remoteDataSource.sendForgetPasswordOTP(params);
  }

  @override
  Future<Either<Failure, void>> verifyForgetPasswordOTP(
    VerifyForgetOTPParams params,
  ) {
    return _remoteDataSource.verifyForgetPasswordOTP(params);
  }

  @override
  Future<Either<Failure, void>> createNewForgetPassword(
    CreateNewForgetParams params,
  ) {
    return _remoteDataSource.createNewForgetPassword(params);
  }

  @override
  Future<Either<Failure, void>> signOut() {
    return _remoteDataSource.logout();
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
  Future<Either<Failure, ChatEntity>> createNormalChat(
      CreateNormalChatParams params) {
    return _remoteDataSource.createNormalChat(params);
  }

  @override
  Future<Either<Failure, ChatEntity>> createAnonymousChat(
      CreateAnonymousChatParams params) {
    return _remoteDataSource.createAnonymousChat(params);
  }
  
  @override
  Future<Either<Failure, bool>> updateProfileView(UpdateProfileViewParams params) {
    return _remoteDataSource.updateProfileView(params);
  }

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViews(GetProfileViewsParams params) {
    return _remoteDataSource.getProfileViews(params);
  }
  
  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> getProfileViewsByUserId(GetProfileViewsParams params) {
    return _remoteDataSource.getProfileViewsByUserId(params);
  }
}
//enum: ['google', 'facebook', 'local', 'apple']
