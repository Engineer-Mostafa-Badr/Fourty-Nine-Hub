import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class ListenToPassengerPickedUpUseCase
    extends NormalUseCase<void, Function(String)> {
  final TripRepository _repo;
  ListenToPassengerPickedUpUseCase(this._repo);

  @override
  void call(Function(String params) params) {
    return _repo.listenToPassengerPickedUp(params);
  }
}
