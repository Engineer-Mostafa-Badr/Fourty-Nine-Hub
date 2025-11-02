import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToClientComingUseCase
    extends NormalUseCase<void, Function(ListenToClientComingParams)> {
  final TripRepository _repo;
  ListenToClientComingUseCase(this._repo);

  @override
  void call(Function(ListenToClientComingParams params) params) {
    return _repo.listenToComingClient(params);
  }
}

class ListenToClientComingParams{
  final String clientId;
  final String remainingTime;

  ListenToClientComingParams({required this.clientId, required this.remainingTime});
}