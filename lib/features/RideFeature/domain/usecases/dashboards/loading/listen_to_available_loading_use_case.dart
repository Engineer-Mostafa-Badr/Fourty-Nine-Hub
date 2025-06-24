import 'package:fourtyninehub/core/abstract/use_case.dart';

import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

import '../../../entities/loading/get_loading_avaliable_entity.dart';


class ListenToAvailableLoadingUseCase
    extends NormalUseCase<void, Function(GetLoadingAvailableEntity)> {
  final TripRepository _repo;
  ListenToAvailableLoadingUseCase(this._repo);

  @override
  void call(Function(GetLoadingAvailableEntity trip) params) {
    return _repo.listenToAvailableLoading(params);
  }
}
