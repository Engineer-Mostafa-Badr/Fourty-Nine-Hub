part of 'dest_get_lat_and_long_cubit.dart';

sealed class DestGetLatAndLongState extends Equatable {
  const DestGetLatAndLongState();

  @override
  List<Object> get props => [];
}

final class DestGetLatAndLongInitial extends DestGetLatAndLongState {}

final class DestGetLatAndLongLoading extends DestGetLatAndLongState {}

final class DestGetLatAndLongSuccess extends DestGetLatAndLongState {
  final LatLongData latLongData;

  DestGetLatAndLongSuccess({required this.latLongData});
}

final class DestGetLatAndLongFailure extends DestGetLatAndLongState {
  final String errorMessage;

  DestGetLatAndLongFailure({required this.errorMessage});
}
