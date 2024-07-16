import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/send_forget_password_otp_use_case.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final SendForgetPasswordOTPUseCase _sendForgetPasswordOTPUseCase;
  final emailFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  ForgotPasswordCubit(
    this._sendForgetPasswordOTPUseCase,
  ) : super(ForgotPasswordInitial());

  Future<void> sendForgetPasswordOTP() async {
    if (!emailFormKey.currentState!.validate()) return;
    if (state is ForgotPasswordLoading) return;
    emit(ForgotPasswordLoading());
    final result = await _sendForgetPasswordOTPUseCase(
      SendForgetOTPParams(
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
