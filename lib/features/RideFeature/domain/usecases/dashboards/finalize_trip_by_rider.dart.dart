import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';


class FinalizeTripByRiderUseCase {
  final RideRepository repository;

  FinalizeTripByRiderUseCase(this.repository);

  Future<Either<Failure, bool>> call(String params) async => await repository.finalizeTripByRider(params);
}

