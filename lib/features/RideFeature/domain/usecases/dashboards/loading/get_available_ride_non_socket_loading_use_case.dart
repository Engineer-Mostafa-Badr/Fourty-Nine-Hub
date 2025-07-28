import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../entities/loading/get_loading_avaliable_entity.dart';
import '../../../repositories/trip_repository.dart';
import '../../get_client_pending_untracked_trips_use_case.dart';



class GetAvailableNonSocketLoadingUseCase extends UseCase<List<GetLoadingAvailableEntity > , ClientPendingTripParams> {
  final TripRepository _repo;

  GetAvailableNonSocketLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetLoadingAvailableEntity >>> call(ClientPendingTripParams params) async {
    return await _repo.getAvailableNonSocketLoading(params);
  }
}
