part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class OTPSent extends RegisterState {}
final class OTPPhoneSent extends RegisterState {}

final class RegisterByPhone extends RegisterState {
  final UserTokensEntity userTokensEntity;
  final bool isPhoneVerified;
  final GiftMessageEntity giftMessageEntity;

  RegisterByPhone(
      {required this.userTokensEntity, required this.isPhoneVerified,required this.giftMessageEntity,});
}

final class RegisterError extends RegisterState {
  final Failure failure;

  RegisterError(this.failure);
}

final class RegisterSuccess extends RegisterState {
  final UserTokensEntity userTokensEntity;

  RegisterSuccess({required this.userTokensEntity});
}
