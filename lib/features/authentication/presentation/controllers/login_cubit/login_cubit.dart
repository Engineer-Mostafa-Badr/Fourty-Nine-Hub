
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/login_cubit/login_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> login(GlobalKey<FormState> formKey) async {
    String? token = await FirebaseMessaging.instance.getToken();
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
        (userToken)async {
          //_attachToken(userToken); // Attach to dio
          // _saveTokens(userToken); // Ensure tokens are saved before proceeding
          // pr('state token is  ${userToken}');
          log("Token logout ${await CacheManager.getAccessToken()}");
          CacheManager.saveAccessToken(userToken.accessToken);
          CacheManager.saveRefreshToken(userToken.refreshToken);
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
  // Future<bool> handleGoogleSignIn() async {
  //  // emit(state.copyWith(status: AuthStatus.authenticating));
  //   try {
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //     if (googleUser == null) {
  //    //   emit(state.copyWith(status: AuthStatus.authenticateCanceled));
  //       return false;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth =
  //     await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential =
  //     await firebaseAuth.signInWithCredential(credential);
  //
  //     if (userCredential.user == null) {
  //      // emit(state.copyWith(status: AuthStatus.authenticateError));
  //       return false;
  //     }
  //
  //     // emit(state.copyWith(
  //     //     status: AuthStatus.authenticated, user: userCredential.user));
  //     return true;
  //   } catch (error, stacktrace) {
  //     debugPrint('Authentication Error: $error\n$stacktrace');
  //    // emit(state.copyWith(status: AuthStatus.authenticateError));
  //     return false;
  //   }
  // }
  // Future<void> signInWithGoogle() async {
  //   if (state is LoginLoading) return;
  //   emit(SocialAuthState(status: AuthStatus.authenticating));
  //
  //   final result = await _googleSignInUseCase(const NoParams());
  //
  //   result.fold(
  //         (failure) => emit(SocialAuthState(status: AuthStatus.authenticateError)),
  //         (userToken) async {
  //       _attachToken(userToken); // Attach to dio
  //       await _saveTokens(userToken); // Ensure tokens are saved before proceeding
  //       emit(LoginSuccess(userTokensEntity: userToken));
  //     },
  //   );
  // }

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
        emit(LoginSuccess(userTokensEntity: userToken));
      },
    );
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Log access token for debugging
        log('Access Token: ${loginResult.accessToken!.token}');
        log('Message: ${loginResult.message}');

        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Sign in with Firebase using the credential
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // Log user details for debugging
        log('Username: ${userCredential.additionalUserInfo?.username}');
        log('Email: ${userCredential.user?.email}');
        log('Photo URL: ${userCredential.user?.photoURL}');

        // Return the signed-in user credential
        return userCredential;
      } else {
        throw Exception('Facebook login failed: ${loginResult.message}');
      }
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

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/core/abstract/use_case.dart';
// import 'package:fourtyninehub/core/error/failure.dart';
// import 'package:fourtyninehub/features/authentication/domain/use_cases/facebook_sign_in_use_case.dart';
// import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
// import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';
//
// import '../../../domain/entities/user_tokens_entity.dart';
// import '../../../domain/use_cases/apple_sign_in_usecase.dart';
// import '../../../domain/use_cases/attach_token_use_case.dart';
// import '../../../domain/use_cases/login_use_case.dart';
//
// part 'login_state.dart';
//
// class LoginCubit extends Cubit<LoginState> {
//   final LoginUseCase _loginUseCase;
//   final GoogleSignInUseCase _googleSignInUseCase;
//   final AppleSignInUseCase _appleSignInUseCase;
//   final FacebookSignInUseCase _facebookSignInUseCase;
//   final SaveTokensUseCase _saveTokens;
//   final AttachTokenUseCase _attachToken;
//   final emailTextController = TextEditingController();
//   final passwordTextController = TextEditingController();
//   final emailFocusNode = FocusNode();
//   final passwordFocusNode = FocusNode();
//
//   LoginCubit(
//     this._loginUseCase,
//     this._saveTokens,
//     this._attachToken,
//     this._googleSignInUseCase,
//     this._facebookSignInUseCase,
//     this._appleSignInUseCase,
//   ) : super(LoginInitial());
//
//   String? token;
//
//   Future<void> login(formKey) async {
//     String? token = await FirebaseMessaging.instance.getToken();
//     if (formKey.currentState!.validate()) {
//       emit(LoginLoading());
//       final result = await _loginUseCase(
//         LoginParams(
//           email: emailTextController.text.trim(),
//           password: passwordTextController.text.trim(),
//           token: token!,
//         ),
//       );
//
//       result.fold(
//         (failure) => emit(LoginError(failure)),
//         (userToken) {
//           print(userToken);
//           _attachToken(userToken); // attach to dio
//           _saveTokens(userToken); // ensure tokens are saved before proceeding
//           emit(LoginSuccess(userTokensEntity: userToken));
//           // print('*****************');
//           // print(token);
//           // print('*****************');
//         },
//       );
//     }
//   }
//
//   Future<void> signInWithGoogle() async {
//     if (state is LoginLoading) return;
//     emit(LoginLoading());
//     final result = await _googleSignInUseCase(const NoParams());
//
//     result.fold(
//       (failure) => emit(LoginError(failure)),
//       (userToken) async {
//         _attachToken(userToken); // attach to dio
//         await _saveTokens(
//             userToken); // ensure tokens are saved before proceeding
//         emit(LoginSuccess(userTokensEntity: userToken));
//       },
//     );
//   }
//
//   Future<void> signInWithApple() async {
//     if (state is LoginLoading) return;
//     emit(LoginLoading());
//     final result = await _appleSignInUseCase(const NoParams());
//
//     result.fold(
//       (failure) => emit(LoginError(failure)),
//       (userToken) async {
//         _attachToken(userToken); // attach to dio
//         await _saveTokens(
//             userToken); // ensure tokens are saved before proceeding
//         emit(LoginSuccess(userTokensEntity: userToken));
//       },
//     );
//   }
//
//   Future<void> signInWithFacebook() async {
//     if (state is LoginLoading) return;
//     emit(LoginLoading());
//     final result = await _facebookSignInUseCase(const NoParams());
//
//     result.fold(
//       (failure) => emit(LoginError(failure)),
//       (userToken) async {
//         _attachToken(userToken); // attach to dio
//         await _saveTokens(
//             userToken); // ensure tokens are saved before proceeding
//         emit(LoginSuccess(userTokensEntity: userToken));
//       },
//     );
//   }
//
//   @override
//   Future<void> close() {
//     emailTextController.dispose();
//     passwordFocusNode.dispose();
//     return super.close();
//   }
// }
