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

final class ChangePasswordLoading extends ForgotPasswordState {}
final class ChangePasswordSuccess extends ForgotPasswordState {}
final class ChangePasswordFailure extends ForgotPasswordState {
  final Failure failure;

  ChangePasswordFailure(this.failure);
}

final class VerifyQuestionsLoading extends ForgotPasswordState {}
final class VerifyQuestionsSuccess extends ForgotPasswordState {}
final class VerifyQuestionsFailure extends ForgotPasswordState {
  final Failure failure;

  VerifyQuestionsFailure(this.failure);
}
