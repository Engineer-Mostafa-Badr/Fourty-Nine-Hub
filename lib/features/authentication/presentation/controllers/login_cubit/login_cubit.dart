import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/facebook_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';

import '../../../domain/use_cases/apple_sign_in_usecase.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final FacebookSignInUseCase _facebookSignInUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  LoginCubit(
    this._loginUseCase,
    this._saveTokens,
    this._attachToken,
    this._googleSignInUseCase,
    this._facebookSignInUseCase,
    this._appleSignInUseCase,
  ) : super(LoginInitial());

  String? token;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoading());
      final result = await _loginUseCase(
        LoginParams(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        ),
      );
      emit(
        result.fold(
          (failure) => LoginError(failure),
          (userToken) {
            print(userToken);
            token = userToken.accessToken.toString();
            _attachToken(userToken); // attach to dio
            _saveTokens(userToken); // save to local storage
            return LoginSuccess();
          },
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    if (state is LoginLoading) return;
    emit(LoginLoading());
    final result = await _googleSignInUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => LoginError(failure),
        (userToken) {
          token = userToken.accessToken.toString();

          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return LoginSuccess();
        },
      ),
    );
  }

  Future<void> signInWithApple() async {
    if (state is LoginLoading) return;
    emit(LoginLoading());
    final result = await _appleSignInUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => LoginError(failure),
        (userToken) {
          token = userToken.accessToken.toString();

          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return LoginSuccess();
        },
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    if (state is LoginLoading) return;
    emit(LoginLoading());
    final result = await _facebookSignInUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => LoginError(failure),
        (userToken) {
          token = userToken.accessToken.toString();

          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return LoginSuccess();
        },
      ),
    );
  }

  @override
  Future<void> close() {
    emailTextController.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
