import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class UpdateDriverLocationUseCase {
  final RideRepository repository;
  UpdateDriverLocationUseCase(this.repository);

  Future<Either<Failure, bool>> call(UpdateDriverLocationUseCaseParams params) {
    return repository.updateDriverLocation(params);
  }
}

class UpdateDriverLocationUseCaseParams {
  final String driverId;
  final double latitude;
  final double longitude;
  UpdateDriverLocationUseCaseParams(this.driverId, this.latitude, this.longitude);

  toJson () => {'driverId': driverId, 'location': [latitude, longitude]};
}