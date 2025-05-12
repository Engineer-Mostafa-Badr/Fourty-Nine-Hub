import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/get_client_pending_trips_entity.dart';
import '../repositories/ride_repository.dart';

class GetClientPendingUntrackedTripsUseCase extends UseCase<List<ClientPendingTripEntity> , ClientPendingTripParams> {
  final RideRepository _repo;

  GetClientPendingUntrackedTripsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ClientPendingTripEntity>>> call(ClientPendingTripParams params) async {
    return await _repo.getClientPendingUntrackedTrips(params: params);
  }
}
class ClientPendingTripParams {
  final int page;
  final int limit;

  ClientPendingTripParams({
    required this.page,
    required this.limit,

  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,


  };
}