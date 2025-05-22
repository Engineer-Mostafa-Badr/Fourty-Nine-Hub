import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/trips_response_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

import '../../entities/dashboards/get_available_ride_non_socket_trip_entity.dart';

class ListenToAvailableUntrackedTripUseCase
    extends NormalUseCase<void, Function(AvailableRideNonSocketTripEntity)> {
  final TripRepository _repo;
  ListenToAvailableUntrackedTripUseCase(this._repo);

  @override
  void call(Function(AvailableRideNonSocketTripEntity trip) params) {
    return _repo.listenToAvailableUntrackedTrip(params);
  }
}
