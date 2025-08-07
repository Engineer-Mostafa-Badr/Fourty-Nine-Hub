import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class ListenToDriverOnWayUseCase
    extends NormalUseCase<void, Function(MyBookingEntity)> {
  final TripRepository _repo;
  ListenToDriverOnWayUseCase(this._repo);

  @override
  void call(Function(MyBookingEntity newBooking) params) {
    return _repo.listenToDriverTheOnWay(params);
  }
}
