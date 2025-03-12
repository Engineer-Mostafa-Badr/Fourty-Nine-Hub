import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class RiderInStartLocationUseCase{
  final RideRepository repository;

  RiderInStartLocationUseCase({required this.repository});

  Future<Either<Failure, bool>> call(RiderInStartLocationUseCaseParams params) {
    return repository.riderInStartLocation(params);
  }
}
class RiderInStartLocationUseCaseParams{
  final String id;

  RiderInStartLocationUseCaseParams({required this.id});
}