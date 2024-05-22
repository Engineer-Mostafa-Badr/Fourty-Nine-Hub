import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/verify_otp_use_case.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOTPUseCase _verifyOTPUseCase;
  String otp = '';

  VerifyOtpCubit(
    this._verifyOTPUseCase,
  ) : super(VerifyOtpInitial());

  void verifyOTP(String email) async {
    if (state is VerifyOtpLoading) return;
    emit(VerifyOtpLoading());
    final result =
        await _verifyOTPUseCase(VerifyOTPParams(email: email, otp: otp));
    emit(
      result.fold(
        (failure) => VerifyOtpError(failure),
        (_) => VerifyOtpSuccess(),
      ),
    );
  }

  void resendOTP(String email) async {
    if (state is VerifyOtpLoading) return;

    // emit(ResendOtpLoading());
    // final result = await _verifyOTPUseCase(ResendOTPParams(email: email));
    // result.fold(
    //   (l) => emit(ResendOtpFailure(l)),
    //   (r) => emit(ResendOtpSuccess(r)),
    // );
  }
}
