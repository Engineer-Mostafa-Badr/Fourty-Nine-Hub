import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class AcceptTripByDriverUseCase{
  final RideRepository repository;

  AcceptTripByDriverUseCase({required this.repository});

  Future<Either<Failure, bool>> call(AcceptTripByDriverUseCaseParams params) {
    return repository.acceptTripByDriver(params);
  }
}
class AcceptTripByDriverUseCaseParams{
  final String tripId;

  AcceptTripByDriverUseCaseParams({required this.tripId});
}