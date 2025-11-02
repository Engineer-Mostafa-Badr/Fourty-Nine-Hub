import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToUpdateLocationDriverUseCase
    extends NormalUseCase<void, Function(UpdateLocationDriverParams params)> {
  final TripRepository _repo;
  ListenToUpdateLocationDriverUseCase(this._repo);

  @override
  void call(Function(UpdateLocationDriverParams params) params) {
    return _repo.listenToUpdateLocationDriver(params);
  }
}

class UpdateLocationDriverParams{
  final double latitude;
  final double longitude;
  UpdateLocationDriverParams({required this.latitude,required this.longitude});
}