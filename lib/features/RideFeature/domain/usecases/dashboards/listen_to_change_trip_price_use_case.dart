import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToUpdateTripPriceUseCase
    extends NormalUseCase<void, Function(UpdateTripPriceEntity)> {
  final TripRepository _repo;
  ListenToUpdateTripPriceUseCase(this._repo);

  @override
  void call(Function(UpdateTripPriceEntity trip) params) {
    return _repo.listenToUpdateTripPrice(params);
  }
}
