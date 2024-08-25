part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class OTPSent extends RegisterState {}

final class RegisterError extends RegisterState {
  final Failure failure;

  RegisterError(this.failure);
}

final class RegisterSuccess extends RegisterState {
  final UserTokensEntity userTokensEntity;

  RegisterSuccess({required this.userTokensEntity});
}
