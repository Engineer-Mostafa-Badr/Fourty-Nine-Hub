part of 'login_cubit.dart';

@immutable
sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginError extends LoginState {
  final Failure failure;

  const LoginError(this.failure);
}

final class LoginSuccess extends LoginState {}
