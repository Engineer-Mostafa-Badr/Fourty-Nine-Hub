import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../entities/dashboards/create_non_track_offer_entity.dart';
import '../../../repositories/trip_repository.dart';
import '../../client_trips/update_client_rate_non_socket_use_case.dart';



class UpdateDriverRateLoadingNonSocketUseCase
    extends UseCase<CreateNonTrackOfferEntity, UpdateClientRateParams> {
  final TripRepository _repo;

  UpdateDriverRateLoadingNonSocketUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity>> call(UpdateClientRateParams params) {
    return _repo.updateDriverRateLoadingNonSocket(params);
  }
}

