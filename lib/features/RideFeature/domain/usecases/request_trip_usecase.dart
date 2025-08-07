import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/request_trip_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_request_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class RequestTripUseCase
    extends UseCase<RideRequestTripEntity, RequestTripUseCaseParams> {
  final RideRepository _repo;
  RequestTripUseCase(this._repo);

  @override
  Future<Either<Failure, RideRequestTripEntity>> call(RequestTripUseCaseParams params) {
    return _repo.requestTrip(params);
  }
}
