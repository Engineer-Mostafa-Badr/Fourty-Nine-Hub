import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/register_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/get_welcome_gift_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final GetWelcomeGiftUseCase _getWelcomeGiftUseCase;
  final RegisterUseCase _registerUseCase;
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

  double? welcomeGift;

  RegisterCubit(
    this._registerUseCase,
    this._getWelcomeGiftUseCase,
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

  void getWelcomeGift() async {
    final result = await _getWelcomeGiftUseCase(const NoParams());
    result.fold(
      (_) {},
      (gift) => welcomeGift = gift,
    );
  }
}
