part of 'accept_trip_for_driver_cubit.dart';

sealed class AcceptTripForDriverState {
  const AcceptTripForDriverState();
}

final class AcceptTripForDriverInitial extends AcceptTripForDriverState {}

final class AcceptTripForDriverFailure extends AcceptTripForDriverState {
  final String errorMessage;

  AcceptTripForDriverFailure({required this.errorMessage});
}

final class AcceptTripForDriverLoading extends AcceptTripForDriverState {}

final class AcceptTripForDriverSuccess extends AcceptTripForDriverState {}
