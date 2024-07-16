part of 'verify_forgot_password_otp_cubit.dart';

@immutable
sealed class VerifyForgotPasswordOtpState {}

final class VerifyForgotPasswordOtpInitial
    extends VerifyForgotPasswordOtpState {}

final class VerifyForgotPasswordOtpLoading
    extends VerifyForgotPasswordOtpState {}

final class VerifyForgotPasswordOtpFailure
    extends VerifyForgotPasswordOtpState {
  final Failure failure;

  VerifyForgotPasswordOtpFailure(this.failure);
}

final class VerifyForgotPasswordOtpSuccess
    extends VerifyForgotPasswordOtpState {}
