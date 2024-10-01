part of 'delete_trips_cubit.dart';

sealed class DeleteTripsState {}

final class DeleteTripsInitial extends DeleteTripsState {}

final class DeleteTripsLoading extends DeleteTripsState {}

final class DeleteTripsFailed extends DeleteTripsState {
  final String message;

  DeleteTripsFailed(this.message);
}

final class DeleteTripsSuccess extends DeleteTripsState {}
