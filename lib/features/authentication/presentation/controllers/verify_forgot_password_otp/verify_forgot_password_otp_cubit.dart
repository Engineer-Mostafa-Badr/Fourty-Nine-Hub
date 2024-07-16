import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/verify_forget_password_otp_use_case.dart';

part 'verify_forgot_password_otp_state.dart';

class VerifyForgotPasswordOtpCubit extends Cubit<VerifyForgotPasswordOtpState> {
  final VerifyForgetPasswordOTPUseCase _verifyForgetPasswordOTPUseCase;

  VerifyForgotPasswordOtpCubit(this._verifyForgetPasswordOTPUseCase)
      : super(VerifyForgotPasswordOtpInitial());

  String otp = '';

  Future<void> verifyOtp(String email) async {
    if (otp.length < 6) return;

    emit(VerifyForgotPasswordOtpLoading());
    final result = await _verifyForgetPasswordOTPUseCase.call(
      VerifyForgetOTPParams(
        email: email,
        otp: otp,
      ),
    );
    result.fold(
      (failure) => emit(VerifyForgotPasswordOtpFailure(failure)),
      (success) => emit(VerifyForgotPasswordOtpSuccess()),
    );
  }
}
