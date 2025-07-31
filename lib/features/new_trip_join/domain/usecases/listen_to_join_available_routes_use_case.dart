import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToJoinAvailableRoutesUseCase
    extends NormalUseCase<void, Function(bool)> {
  final TripRepository _repo;
  ListenToJoinAvailableRoutesUseCase(this._repo);

  @override
  void call(Function(bool isJoined) params) {
    return _repo.listenToJoinAvailableRoutes(params);
  }
}
