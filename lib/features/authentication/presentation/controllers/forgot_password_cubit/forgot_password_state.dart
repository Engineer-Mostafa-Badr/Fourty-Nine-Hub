part of 'forgot_password_cubit.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSendOTPSuccess extends ForgotPasswordState {}

final class ForgotPasswordSendOTPFailure extends ForgotPasswordState {
  final Failure failure;

  ForgotPasswordSendOTPFailure(this.failure);
}
