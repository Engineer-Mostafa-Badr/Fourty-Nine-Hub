import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/save_tokens_use_case.dart';

import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
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
  ) : super(LoginInitial());

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
            _attachToken(userToken.accessToken); // attach to dio
            _saveTokens(userToken); // save to local storage
            return LoginSuccess();
          },
        ),
      );
    }
  }

  @override
  Future<void> close() {
    emailTextController.dispose();
    passwordFocusNode.dispose();
    return super.close();
  }
}
