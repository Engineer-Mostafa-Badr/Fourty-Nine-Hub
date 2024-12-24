part of 'get_lat_and_long_cubit.dart';

sealed class GetLatAndLongState extends Equatable {
  const GetLatAndLongState();

  @override
  List<Object> get props => [];
}

final class GetLatAndLongInitial extends GetLatAndLongState {}

final class GetLatAndLongLoading extends GetLatAndLongState {}

final class GetLatAndLongSuccess extends GetLatAndLongState {
  final LatLongData latLongData;

  const GetLatAndLongSuccess({required this.latLongData});
}

final class GetLatAndLongFailure extends GetLatAndLongState {
  final String errorMessage;

  const GetLatAndLongFailure({required this.errorMessage});
}
