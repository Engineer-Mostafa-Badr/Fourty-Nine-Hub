import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToTripAcceptedUseCase
    extends NormalUseCase<void, Function(String)> {
  final TripRepository _repo;
  ListenToTripAcceptedUseCase(this._repo);

  @override
  void call(Function(String params) params) {
    return _repo.listenToTripAccept(params);
  }
}
