import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class CancelPendingTripByClientUseCase {
  final RideRepository repository;

  CancelPendingTripByClientUseCase(this.repository);

  Future<Either<Failure, bool>> call(CancelPendingTripByClientUseCaseParams params) async => await repository.cancelPendingTripByClient(params);
}

class CancelPendingTripByClientUseCaseParams {
  final String tripId;

  CancelPendingTripByClientUseCaseParams({required this.tripId});

}