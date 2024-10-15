import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';

sealed class GetAllTripsState {}

final class GetAllTripsInitial extends GetAllTripsState {}

final class GetAllTripsLoading extends GetAllTripsState {}

final class GetAllTripsSuccess extends GetAllTripsState {
  final List<CarpoolTripParam> trips;

  GetAllTripsSuccess(this.trips);
}

final class GetAllTripsFailure extends GetAllTripsState {
  final String errorMessage;

  GetAllTripsFailure(this.errorMessage);
}
