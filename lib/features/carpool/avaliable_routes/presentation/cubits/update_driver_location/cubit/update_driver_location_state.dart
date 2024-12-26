part of 'update_driver_location_cubit.dart';

sealed class UpdateDriverLocationState {
  const UpdateDriverLocationState();
}

final class UpdateDriverLocationInitial extends UpdateDriverLocationState {}

final class UpdateDriverLocationLoading extends UpdateDriverLocationState {}

final class UpdateDriverLocationFailure extends UpdateDriverLocationState {
  final String errorMessage;

  UpdateDriverLocationFailure({required this.errorMessage});
}

final class UpdateDriverLocationSuccess extends UpdateDriverLocationState {}
