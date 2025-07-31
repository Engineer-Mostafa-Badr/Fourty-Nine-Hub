import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToLeaveAvailableRoutesUseCase
    extends NormalUseCase<void, Function(String)> {
  final TripRepository _repo;
  ListenToLeaveAvailableRoutesUseCase(this._repo);

  @override
  void call(Function(String routeId) params) {
    return _repo.listenToLeaveAvailableRoutes(params);
  }
}
