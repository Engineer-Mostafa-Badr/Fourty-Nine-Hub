import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_state.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/shared/constants.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/shared_web_socket.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../../../domain/use_cases/apple_sign_in_usecase.dart';
import '../../../domain/use_cases/login_use_case.dart';
import '../../../domain/use_cases/save_tokens_use_case.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  LoginCubit(
    this._loginUseCase,
    this._saveTokens,
    this._attachToken,
    this._appleSignInUseCase, {
    required this.googleSignIn,
    required this.firebaseAuth,
  }) : super(LoginInitial());

  String? token;

  Future<void> login(GlobalKey<FormState> formKey, BuildContext context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("all tokens before login : ${await CacheManager.getAccessToken()}");

    if (formKey.currentState!.validate()) {
      emit(LoginLoading());
      final result = await _loginUseCase(
        LoginParams(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
          token: token!,
        ),
    );

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

  User? user = FirebaseAuth.instance.currentUser;

  Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();

    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  Future<void> signInWithApple() async {
    if (state is LoginLoading) return;
    emit(const SocialAuthState(status: AuthStatus.authenticating));

    final result = await _appleSignInUseCase(const NoParams());

    result.fold(
      (failure) =>
          emit(const SocialAuthState(status: AuthStatus.authenticateError)),
      (userToken) async {
        _attachToken(userToken); // Attach to dio
        await _saveTokens(
            userToken); // Ensure tokens are saved before proceeding
        // emit(LoginSuccess(userTokensEntity: userToken));
      },
    );
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      // final LoginResult loginResult = await FacebookAuth.instance.login();

      // if (loginResult.status == LoginStatus.success) {
      //   // Log access token for debugging
      //   // log('Access Token: ${loginResult.accessToken!.token}');
      //   log('Message: ${loginResult.message}');

      //   // Create a credential from the access token
      //   final OAuthCredential facebookAuthCredential =
      //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

      //   // Sign in with Firebase using the credential
      //   UserCredential userCredential = await FirebaseAuth.instance
      //       .signInWithCredential(facebookAuthCredential);

      //   // Log user details for debugging
      //   log('Username: ${userCredential.additionalUserInfo?.username}');
      //   log('Email: ${userCredential.user?.email}');
      //   log('Photo URL: ${userCredential.user?.photoURL}');

      //   // Return the signed-in user credential
      //   return userCredential;
      // } else {
        throw Exception('Facebook login failed: ${''}');
      // }
    } catch (e) {
      log('Error during Facebook sign-in: $e');
      rethrow;
    }
  }

  @override
  Future<void> close() {
    emailTextController.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
