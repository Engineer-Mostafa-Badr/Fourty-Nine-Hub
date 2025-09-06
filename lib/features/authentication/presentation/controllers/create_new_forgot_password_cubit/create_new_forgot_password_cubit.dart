import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/create_new_forget_password_use_case.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import '../../../../../core/utils/shared_pref.dart';

part 'create_new_forgot_password_state.dart';

class CreateNewForgotPasswordCubit extends Cubit<CreateNewForgotPasswordState> {
  final CreateNewForgetPasswordUseCase _createNewForgetPasswordUseCase;
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  CreateNewForgotPasswordCubit(
    this._createNewForgetPasswordUseCase,
  ) : super(CreateNewForgotPasswordInitial());

  Future<void> createPassword(Map<String,dynamic> emailOrUserId) async {
    if (formKey.currentState!.validate()) {
      emit(CreateNewForgotPasswordLoading());
      final result = await _createNewForgetPasswordUseCase.call(
        CreateNewForgetParams(
          email: emailOrUserId['email'],
          userId: emailOrUserId['userId'],
          newPassword: newPasswordController.text,
          newPasswordConfirmation: confirmPasswordController.text,
        ),
      );
      result.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(CreateNewForgotPasswordFailure(failure));
        },
        (success) async {
          // Clear the forgot password timer when password is successfully changed
          await CacheManager.clearForgotPasswordTimer();
          emit(CreateNewForgotPasswordSuccess());
        },
      );
    }
  }
}
