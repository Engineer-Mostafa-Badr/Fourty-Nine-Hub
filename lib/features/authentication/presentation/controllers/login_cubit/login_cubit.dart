import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/data/data_sources/remote_data_source/auth_remote_data_source.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/firebase_auth_service_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/signIn_as_guest_use_case.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_state.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/user_tokens_entity.dart';
import '../../../domain/use_cases/apple_sign_in_usecase.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/login_use_case.dart';
import '../../../domain/use_cases/login_with_phone_use_case.dart';
import '../../../domain/use_cases/save_tokens_use_case.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final LoginWithPhoneUseCase _loginWithPhoneUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final SignInAsGuestUseCase _signInAsGuestUseCase;
  final SocialAuthService _socialAuthService;
  final AuthRemoteDataSource _authRemoteDataSource;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  String? token;

  User? user = FirebaseAuth.instance.currentUser;

  final GoogleSignIn googleSignIn;

  final FirebaseAuth firebaseAuth;

  LoginCubit(
    this._loginUseCase,
    this._loginWithPhoneUseCase,
    this._saveTokens,
    this._attachToken,
    this._appleSignInUseCase,
    this._signInAsGuestUseCase,
    this._socialAuthService,
    this._authRemoteDataSource, {
    required this.googleSignIn,
    required this.firebaseAuth,
  }) : super(LoginInitial());

  @override
  Future<void> close() {
    emailTextController.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }

  Future<void> login(GlobalKey<FormState> formKey) async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("all tokens before login : ${await CacheManager.getAccessToken()}");

    if (formKey.currentState!.validate()) {
      Either<Failure, UserTokensEntity> result;
      emit(LoginLoading());
      if (_isEmail(emailTextController.text.trim())) {
        result = await _loginUseCase(
          LoginParams(
            email: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
            token: token ?? "",
          ),
        );
      } else {
        result = await _loginWithPhoneUseCase(
          LoginWithPhoneParams(
            phoneNumber: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
            token: token ?? "",
          ),
        );
      }

      result.fold(
        (failure) => emit(LoginError(failure)),
        (userToken) async {
          //_attachToken(userToken); // Attach to dio
          // _saveTokens(userToken); // Ensure tokens are saved before proceeding
          // pr('state token is  ${userToken}');
          log("Token logout ${await CacheManager.getAccessToken()}");
          log("Token userToken access ${userToken.accessToken}");
          log("Token userToken refresh ${userToken.refreshToken}");
          await CacheManager.saveAccessToken(userToken.accessToken);
          await CacheManager.saveRefreshToken(userToken.refreshToken);

          // await DI.reset();
          // await DI.execute(token: await CacheManager.getAccessToken());
          // serviceLocator<Socket>().connect();
          // ignore: use_build_context_synchronously
          SharedWebSocket.connect(token: userToken.accessToken);
          emit(LoginSuccess(userTokensEntity: userToken));
        },
      );
    }
  }

  // تسجيل دخول كـ Guest
  Future<void> signInAsGuest() async {
    emit(LoginLoading());

    final result = await _signInAsGuestUseCase(const NoParams());

    result.fold(
      (failure) => emit(LoginError(failure)),
      (guestUser) => emit(LoginGuestSuccess(user: guestUser)),
    );
  }

  // Future<void> signInWithApple() async {
  //   if (state is LoginLoading) return;
  //   emit(const SocialAuthState(status: AuthStatus.authenticating));

  //   final result = await _appleSignInUseCase(const NoParams());

  //   result.fold(
  //     (failure) =>
  //         emit(const SocialAuthState(status: AuthStatus.authenticateError)),
  //     (userToken) async {
  //       _attachToken(userToken); // Attach to dio
  //       await _saveTokens(
  //           userToken); // Ensure tokens are saved before proceeding
  //       // emit(LoginSuccess(userTokensEntity: userToken));
  //     },
  //   );
  // }

  Future<void> signInWithApple() async {
    if (!Platform.isIOS) {
      emit(const SocialAuthState(status: AuthStatus.authenticateError));
      return;
    }

    emit(const SocialAuthState(status: AuthStatus.authenticating));

    try {
      // Sign in with Firebase
      final userCredential = await _socialAuthService.signInWithApple();

      if (userCredential?.user != null) {
        await _handleSocialLogin(userCredential!);
      } else {
        emit(const SocialAuthState(status: AuthStatus.authenticateCanceled));
      }
    } catch (e) {
      print('Apple Sign-In Error: $e');
      emit(const SocialAuthState(status: AuthStatus.authenticateError));
    }
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   try {
  //     // Trigger the sign-in flow
  //     // final LoginResult loginResult = await FacebookAuth.instance.login();

  //     // if (loginResult.status == LoginStatus.success) {
  //     //   // Log access token for debugging
  //     //   // log('Access Token: ${loginResult.accessToken!.token}');
  //     //   log('Message: ${loginResult.message}');

  //     //   // Create a credential from the access token
  //     //   final OAuthCredential facebookAuthCredential =
  //     //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     //   // Sign in with Firebase using the credential
  //     //   UserCredential userCredential = await FirebaseAuth.instance
  //     //       .signInWithCredential(facebookAuthCredential);

  //     //   // Log user details for debugging
  //     //   log('Username: ${userCredential.additionalUserInfo?.username}');
  //     //   log('Email: ${userCredential.user?.email}');
  //     //   log('Photo URL: ${userCredential.user?.photoURL}');

  //     //   // Return the signed-in user credential
  //     //   return userCredential;
  //     // } else {
  //     throw Exception('Facebook login failed: ${''}');
  //     // }
  //   } catch (e) {
  //     log('Error during Facebook sign-in: $e');
  //     rethrow;
  //   }
  // }

  Future<void> signInWithFacebook() async {
    emit(const SocialAuthState(status: AuthStatus.authenticating));

    try {
      // Sign in with Firebase
      final userCredential = await _socialAuthService.signInWithFacebook();

      if (userCredential?.user != null) {
        await _handleSocialLogin(userCredential!);
      } else {
        emit(const SocialAuthState(status: AuthStatus.authenticateCanceled));
      }
    } catch (e) {
      print('Facebook Sign-In Error: $e');
      emit(const SocialAuthState(status: AuthStatus.authenticateError));
    }
  }

  // Future<User?> loginWithGoogle() async {
  //   final googleAccount = await GoogleSignIn().signIn();

  //   final googleAuth = await googleAccount?.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   final userCredential = await FirebaseAuth.instance.signInWithCredential(
  //     credential,
  //   );
  //   return userCredential.user;
  // }
  Future<void> signInWithGoogle() async {
    emit(const SocialAuthState(status: AuthStatus.authenticating));

    try {
      // Sign in with Firebase
      final userCredential = await _socialAuthService.signInWithGoogle();

      if (userCredential?.user != null) {
        await _handleSocialLogin(userCredential!);
      } else {
        emit(const SocialAuthState(status: AuthStatus.authenticateCanceled));
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      emit(const SocialAuthState(status: AuthStatus.authenticateError));
    }
  }


  // Handle Social Login with Backend
  Future<void> _handleSocialLogin(UserCredential userCredential) async {
    try {
      // Get ID Token from Firebase
      final idToken = await userCredential.user?.getIdToken();
      
      if (idToken == null) {
        emit(const SocialAuthState(status: AuthStatus.authenticateError));
        return;
      }

      // Get FCM Token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      
      // Get Device ID
      final deviceId = await _getDeviceId();

      // Create social login params
      final socialLoginParams = SocialLoginParams(
        idToken: idToken,
        fcmToken: fcmToken ?? '',
        deviceId: deviceId,
      );

      // Call backend API
      final result = await _authRemoteDataSource.socialLogin(socialLoginParams);

      result.fold(
        (failure) => emit(SocialAuthState(
          status: AuthStatus.authenticateError,
          error: failure,
        )),
        (userTokens) async {
          // Save tokens
          await _saveTokens(userTokens);
          _attachToken(userTokens);
          
          emit(SocialAuthState(
            status: AuthStatus.authenticated,
            userTokensEntity: userTokens,
          ));
        },
      );
    } catch (e) {
      print('Handle Social Login Error: $e');
      emit(const SocialAuthState(status: AuthStatus.authenticateError));
    }
  }

  // Get Device ID
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
}

  bool _isEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  bool _isPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(input);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
