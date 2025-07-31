import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';

class ListenToNewRouteDriverUseCase
    extends NormalUseCase<void, Function(MyBookingEntity)> {
  final TripRepository _repo;
  ListenToNewRouteDriverUseCase(this._repo);

  @override
  void call(Function(MyBookingEntity newBooking) params) {
    return _repo.listenToNewRouteDriver(params);
  }
}
