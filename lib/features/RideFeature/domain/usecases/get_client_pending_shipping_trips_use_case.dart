import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_client_pending_untracked_trips_use_case.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/get_client_pending_trips_entity.dart';
import '../repositories/ride_repository.dart';

class GetClientPendingShippingTripsUseCase extends UseCase<List<ClientPendingTripEntity> , ClientPendingTripParams> {
  final RideRepository _repo;

  GetClientPendingShippingTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ClientPendingTripEntity>>> call(ClientPendingTripParams params) async {
    return await _repo.getClientPendingShippingTrips(params: params);
  }
}
