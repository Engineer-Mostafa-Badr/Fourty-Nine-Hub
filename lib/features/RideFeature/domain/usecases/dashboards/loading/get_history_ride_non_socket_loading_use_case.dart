import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../entities/loading/get_loading_history_entity.dart';
import '../../../repositories/trip_repository.dart';
import '../../get_client_pending_untracked_trips_use_case.dart';



class GetHistoryNonSocketLoadingUseCase extends UseCase<List<GetLoadingHistoryEntity > , ClientPendingTripParams> {
  final TripRepository _repo;

  GetHistoryNonSocketLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetLoadingHistoryEntity >>> call(ClientPendingTripParams params) async {
    return await _repo.getHistoryNonSocketLoading(params);
  }
}
