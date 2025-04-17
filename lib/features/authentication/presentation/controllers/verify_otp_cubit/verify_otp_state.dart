part of 'verify_otp_cubit.dart';

@immutable
sealed class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpLoading extends VerifyOtpState {}

final class VerifyOtpSuccess extends VerifyOtpState {
  final UserTokensEntity userTokensEntity;
  final GiftMessageEntity giftMessageEntity;

  VerifyOtpSuccess({required this.userTokensEntity,required this.giftMessageEntity});
}

final class VerifyOtpError extends VerifyOtpState {
  final Failure failure;

  VerifyOtpError(this.failure);
}

final class ResendOtpLoading extends VerifyOtpState {}

final class ResendOtpSuccess extends VerifyOtpState {}

final class ResendOtpError extends VerifyOtpState {
  final Failure failure;

  ResendOtpError(this.failure);
}
class ResendOtpEnabled extends VerifyOtpState {}

class ResendOtpDisabled extends VerifyOtpState {}