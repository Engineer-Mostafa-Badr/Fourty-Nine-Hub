part of 'create_trip_rider_cubit.dart';

@immutable
sealed class CreateTripRiderState {}

final class CreateTripRiderInitial extends CreateTripRiderState {
}
class CreateTripRiderError extends CreateTripRiderState {
  final String message;

  CreateTripRiderError({required this.message});
}
class CreateTripRiderSuccess extends CreateTripRiderState {
}