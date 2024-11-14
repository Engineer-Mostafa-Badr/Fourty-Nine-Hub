part of 'here_location_cubit.dart';

sealed class HereLocationState {
  const HereLocationState();
}

final class HereLocationInitial extends HereLocationState {}

final class HereLocationLoading extends HereLocationState {}

final class HereLocationSuccess extends HereLocationState {
  final List<double> locations;

  HereLocationSuccess({required this.locations});
}

final class HereLocationFailure extends HereLocationState {
  final String errorMessage;

  HereLocationFailure({required this.errorMessage});
}
