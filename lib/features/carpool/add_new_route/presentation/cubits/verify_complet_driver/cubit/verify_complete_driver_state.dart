part of 'verify_complete_driver_cubit.dart';

sealed class VerifyCompleteDriverState {
  const VerifyCompleteDriverState();
}

final class VerifyCompleteDriverInitial extends VerifyCompleteDriverState {}

final class VerifyOtpLoading extends VerifyCompleteDriverState {}

final class VerifyOtpSuccess extends VerifyCompleteDriverState {}

final class VerifyOtpFailure extends VerifyCompleteDriverState {
  final String errorMessage;

  VerifyOtpFailure({required this.errorMessage});
}

final class CompleteSeatLoading extends VerifyCompleteDriverState {}

final class CompleteSeatFailure extends VerifyCompleteDriverState {
  final String errorMessage;

  CompleteSeatFailure({required this.errorMessage});
}

final class CompleteSeatSuccess extends VerifyCompleteDriverState {}

final class GetAcceptedTripFailure extends VerifyCompleteDriverState {
  final String errorMessage;

  GetAcceptedTripFailure({required this.errorMessage});
}

final class GetAcceptedTripLoading extends VerifyCompleteDriverState {}

final class GetAcceptedTripSuccess extends VerifyCompleteDriverState {
  final CarpoolTripParam carpoolTripParam;

  GetAcceptedTripSuccess({required this.carpoolTripParam});
}
