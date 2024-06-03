import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/resend_otp_use_case.dart';
import '../../../domain/use_cases/save_tokens_use_case.dart';
import '../../../domain/use_cases/verify_otp_use_case.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOTPUseCase _verifyOTPUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final ResendOTPUseCase _resendOTPUseCase;
  String otp = '';

  VerifyOtpCubit(
    this._verifyOTPUseCase,
    this._saveTokens,
    this._attachToken,
    this._resendOTPUseCase,
  ) : super(VerifyOtpInitial());

  void verifyOTP(String email) async {
    if (state is VerifyOtpLoading) return;
    emit(VerifyOtpLoading());
    final result =
        await _verifyOTPUseCase(VerifyOTPParams(email: email, otp: otp));
    emit(
      result.fold(
        (failure) => VerifyOtpError(failure),
        (userToken) {
          _attachToken(userToken); // attach to dio
          _saveTokens(userToken); // save to local storage
          return VerifyOtpSuccess();
        },
      ),
    );
  }

  void resendOTP(String email) async {
    if (state is VerifyOtpLoading) return;

    emit(ResendOtpLoading());
    final result = await _resendOTPUseCase(ResendOTPParams(email: email));
    result.fold(
      (l) => emit(ResendOtpError(l)),
      (_) => emit(ResendOtpSuccess()),
    );
  }
}
