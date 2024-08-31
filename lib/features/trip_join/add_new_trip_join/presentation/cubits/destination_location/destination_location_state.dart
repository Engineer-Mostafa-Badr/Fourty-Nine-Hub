part of 'destination_location_cubit.dart';

sealed class DestinationLocationState extends Equatable {
  const DestinationLocationState();

  @override
  List<Object> get props => [];
}

final class DestinationLocationInitial extends DestinationLocationState {}

final class DestinationLocationLoading extends DestinationLocationState {}

final class DestinationLocationFailed extends DestinationLocationState {
  final String errorMessage;

  const DestinationLocationFailed({required this.errorMessage});
}

final class DestinationLocationSuccess extends DestinationLocationState {
  final LocationEntity locationEntity;

  const DestinationLocationSuccess({required this.locationEntity});
}
