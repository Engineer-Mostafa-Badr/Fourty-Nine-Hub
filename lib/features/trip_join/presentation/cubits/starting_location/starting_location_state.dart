part of 'starting_location_cubit.dart';

sealed class StartingLocationState {}

final class StartingLocationInitial extends StartingLocationState {}

final class StartingLocationLoading extends StartingLocationState {}

final class StartingLocationFailed extends StartingLocationState {
  final String errorMessage;

  StartingLocationFailed({required this.errorMessage});
}

final class StartingLocationSuccess extends StartingLocationState {
  final LocationEntity locationEntity;

  StartingLocationSuccess({required this.locationEntity});
}
