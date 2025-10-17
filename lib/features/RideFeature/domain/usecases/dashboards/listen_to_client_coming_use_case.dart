import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToClientComingTrackingUseCase
    extends NormalUseCase<void, Function(String)> {
  final TripRepository _repo;
  ListenToClientComingTrackingUseCase(this._repo);

  @override
  void call(Function(String tripId) params) {
    return _repo.listenToClientComing(params);
  }
}
