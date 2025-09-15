import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/driver_ratings_entity.dart';
import '../repositories/ride_repository.dart';

class GetDriverRatingsUseCase {
  final RideRepository repository;

  GetDriverRatingsUseCase(this.repository);

  Future<Either<Failure, DriverRatingsEntity>> call({required String driverId}) async => await repository.getDriverRatings(driverId: driverId);
}