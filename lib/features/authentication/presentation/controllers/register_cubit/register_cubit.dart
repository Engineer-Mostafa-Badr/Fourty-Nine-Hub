import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/facebook_sign_in_use_case.dart';
import '../../../domain/use_cases/get_welcome_gift_use_case.dart';
import '../../../domain/use_cases/google_sign_in_use_case.dart';
import '../../../domain/use_cases/save_tokens_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final GetWelcomeGiftUseCase _getWelcomeGiftUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final FacebookSignInUseCase _facebookSignInUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  bool accept = false;
  bool isMale = true;
  double? welcomeGift;

  RegisterCubit(
    this._registerUseCase,
    this._getWelcomeGiftUseCase,
    this._saveTokens,
    this._attachToken,
    this._googleSignInUseCase,
    this._facebookSignInUseCase,
  ) : super(RegisterInitial());

  Future<void> register() async {
    if (state is RegisterLoading) return;
    if (formKey.currentState!.validate()) {
      emit(RegisterLoading());
      final result = await _registerUseCase(
        RegisterParams(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
          confirmPassword: confirmPasswordTextController.text.trim(),
          isMale: isMale,
        ),
      );
      emit(
        result.fold(
          (failure) => RegisterError(failure),
          (_) => OTPSent(),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    if (state is RegisterLoading) return;
    emit(RegisterLoading());
    final result = await _googleSignInUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => RegisterError(failure),
        (userToken) {
          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return RegisterSuccess();
        },
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    if (state is RegisterLoading) return;
    emit(RegisterLoading());
    final result = await _facebookSignInUseCase(const NoParams());
    emit(
      result.fold(
        (failure) => RegisterError(failure),
        (userToken) {
          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return RegisterSuccess();
        },
      ),
    );
  }

  void getWelcomeGift() async {
    final result = await _getWelcomeGiftUseCase(const NoParams());
    result.fold(
      (_) {},
      (gift) => welcomeGift = gift,
    );
  }
}
