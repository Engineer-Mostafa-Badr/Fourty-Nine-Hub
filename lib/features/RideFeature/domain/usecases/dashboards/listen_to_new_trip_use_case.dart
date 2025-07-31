import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/available_ride_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToNewTripUseCase
    extends NormalUseCase<void, Function(AvailableRideTripEntity)> {
  final TripRepository _repo;
  ListenToNewTripUseCase(this._repo);

  @override
  void call(Function(AvailableRideTripEntity trip) params) {
    return _repo.listenToNewTrip(params);
  }
}
