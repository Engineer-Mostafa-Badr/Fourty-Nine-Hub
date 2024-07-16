part of 'create_new_forgot_password_cubit.dart';

@immutable
sealed class CreateNewForgotPasswordState {}

final class CreateNewForgotPasswordInitial
    extends CreateNewForgotPasswordState {}

final class CreateNewForgotPasswordLoading
    extends CreateNewForgotPasswordState {}

final class CreateNewForgotPasswordFailure
    extends CreateNewForgotPasswordState {
  final Failure failure;

  CreateNewForgotPasswordFailure(this.failure);
}

final class CreateNewForgotPasswordSuccess
    extends CreateNewForgotPasswordState {}
