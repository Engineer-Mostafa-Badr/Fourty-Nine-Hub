import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/send_forget_password_otp_use_case.dart';
import '../../../domain/use_cases/send_forget_password_question_use_case.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendForgetPasswordOTPUseCase _sendForgetPasswordOTPUseCase;
  final SendForgetPasswordQuestionUseCase _sendForgetPasswordQuestionsUseCase;
  final emailFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  ForgotPasswordCubit(
    this._sendForgetPasswordOTPUseCase,
    this._sendForgetPasswordQuestionsUseCase,
  ) : super(ForgotPasswordInitial());

  Future<void> sendForgetPasswordOTP() async {
    if (!emailFormKey.currentState!.validate()) return;
    if (state is ForgotPasswordLoading) return;
    emit(ForgotPasswordLoading());

    if (_isPhoneNumber(emailController.text.trim())) {
      final result = await _sendForgetPasswordQuestionsUseCase(
        SendForgetPasswordParams(
          email: emailController.text.trim(),
        ),
      );
      result.fold(
        (failure) => emit(ForgotPasswordSendOTPFailure(failure)),
        (questions) => {

        },
      );
    } else if (_isEmail(emailController.text.trim())) {
      final result = await _sendForgetPasswordOTPUseCase(
        SendForgetPasswordParams(
          email: emailController.text.trim(),
        ),
      );
      emit(
        result.fold(
          (failure) => ForgotPasswordSendOTPFailure(failure),
          (_) => ForgotPasswordSendOTPSuccess(),
        ),
      );
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
}
