import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../data/models/loading/get_loading_accepted_model.dart';
import '../../../repositories/trip_repository.dart';
import '../../get_client_pending_untracked_trips_use_case.dart';



class GetAcceptedNonSocketLoadingUseCase extends UseCase<List<GetLoadingAcceptedEntity > , ClientPendingTripParams> {
  final TripRepository _repo;

  GetAcceptedNonSocketLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetLoadingAcceptedEntity >>> call(ClientPendingTripParams params) async {
    return await _repo.getAcceptedNonSocketLoading( params);
  }
}
