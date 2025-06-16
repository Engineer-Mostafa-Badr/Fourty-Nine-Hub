import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class GetAvailableMapCountryUseCase {
  final RideRepository repository;

  GetAvailableMapCountryUseCase(this.repository);

  Future<Either<Failure, String>> call() {
    return repository.getAvailableMapCountry();
  }
}