import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/gift_message_entity.dart';
import '../../../domain/entities/user_tokens_entity.dart';
import '../../../domain/use_cases/attach_token_use_case.dart';
import '../../../domain/use_cases/resend_otp_use_case.dart';
import '../../../domain/use_cases/save_tokens_use_case.dart';
import '../../../domain/use_cases/verify_otp_use_case.dart';
import '../../../domain/use_cases/verify_phone_otp_use_case.dart';

part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final VerifyOTPUseCase _verifyOTPUseCase;
  final VerifyPhoneOtpUseCase _verifyPhoneOTPUseCase;
  final SaveTokensUseCase _saveTokens;
  final AttachTokenUseCase _attachToken;
  final ResendOTPUseCase _resendOTPUseCase;
  String otp = '';
  bool isTimeOff = false;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 300;
  late CountdownTimerController controller;

  VerifyOtpCubit(
    this._verifyOTPUseCase,
    this._verifyPhoneOTPUseCase,
    this._saveTokens,
    this._attachToken,
    this._resendOTPUseCase,
  ) : super(VerifyOtpInitial()) {
    _initializeTimer();
  }

  void _initializeTimer() {
    print("Initializing timer...");
    endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60;
    print("New endTime: $endTime");
    // controller.dispose();
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    print("Timer initialized successfully");
  }

  void verifyOTP(String email) async {
    if (state is VerifyOtpLoading) return;
    emit(VerifyOtpLoading());
    final result =
        await _verifyOTPUseCase(VerifyOTPParams(email: email, otp: otp));
    emit(
      result.fold(
        (failure)  {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        return   VerifyOtpError(failure);
        },
        (data) {
          _attachToken(data.userTokensEntity);
          _saveTokens(data.userTokensEntity);
          return VerifyOtpSuccess(userTokensEntity: data.userTokensEntity,giftMessageEntity: data.giftMessageEntity);
        },
      ),
    );
  }

  void verifyPhoneOTP(String phoneNumber) async {
    if (state is VerifyOtpLoading) return;
    emit(VerifyOtpLoading());
    final result = await _verifyPhoneOTPUseCase(
      VerifyPhoneOTPParams(
        phoneNumber: phoneNumber,
        otp: otp,
      ),
    );
    emit(
      result.fold(
        (failure) => VerifyOtpError(failure),
        (data) {
          _attachToken(data.userTokensEntity);
          _saveTokens(data.userTokensEntity);
          return VerifyOtpSuccess(userTokensEntity: data.userTokensEntity, giftMessageEntity: data.giftMessageEntity);
        },
      ),
    );
  }

  void onEnd() {
    print("Timer ended, enabling resend button");
    isTimeOff = true;
    emit(ResendOtpEnabled());
  }

  void resendOTP(String email, bool forVerification) async {
    if (state is VerifyOtpLoading) return;
    emit(ResendOtpLoading());

    final result = await _resendOTPUseCase(ResendOTPParams(email: email, forVerification: forVerification));
    result.fold(
      (l) {
        emit(ResendOtpError(l));
      },
      (_) {
        isTimeOff = false;
        _initializeTimer();
        emit(ResendOtpSuccess());
        emit(ResendOtpDisabled());
      },
    );
  }
}
