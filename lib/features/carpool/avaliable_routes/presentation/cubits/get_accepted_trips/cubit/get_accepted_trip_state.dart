part of 'get_accepted_trip_cubit.dart';

sealed class GetAcceptedTripState {
  const GetAcceptedTripState();
}

final class GetAcceptedTripInitial extends GetAcceptedTripState {}

final class GetAcceptedTripSuccess extends GetAcceptedTripState {
  final CarpoolTripParam carpoolTripParam;

  GetAcceptedTripSuccess({required this.carpoolTripParam});
}

final class GetAcceptedTripFailure extends GetAcceptedTripState {
  final String errorMessage;

  GetAcceptedTripFailure({required this.errorMessage});
}

final class GetAcceptedTripLoading extends GetAcceptedTripState {}
