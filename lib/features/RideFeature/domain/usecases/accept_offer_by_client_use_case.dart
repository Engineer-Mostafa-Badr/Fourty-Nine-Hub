import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class AcceptOfferByClientUseCase
    extends UseCase<RideRequestTripEntity, String> {
  final RideRepository _repo;
  AcceptOfferByClientUseCase(this._repo);

  @override
  Future<Either<Failure, RideRequestTripEntity>> call(String params) {
    return _repo.acceptOfferByClient(params);();
  }
}
