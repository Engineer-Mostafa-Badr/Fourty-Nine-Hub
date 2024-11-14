part of 'get_available_trips_for_drivers_cubit.dart';

sealed class GetAvailableTripsForDriversState {
  const GetAvailableTripsForDriversState();
}

final class GetAvailableTripsForDriversInitial
    extends GetAvailableTripsForDriversState {}

final class GetAvailableTripsForDriversLoading
    extends GetAvailableTripsForDriversState {}

final class GetAvailableTripsForDriversFailure
    extends GetAvailableTripsForDriversState {
  final String errorMessage;

  GetAvailableTripsForDriversFailure({required this.errorMessage});
}

final class GetAvailableTripsForDriversSuccess
    extends GetAvailableTripsForDriversState {
  final List<CarpoolTripParam> trips;

  GetAvailableTripsForDriversSuccess({required this.trips});
}
