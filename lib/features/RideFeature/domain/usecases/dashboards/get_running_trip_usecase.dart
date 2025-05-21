import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class GetRunningTripUseCase extends UseCase<RunningTripEntity, NoParams> {
  final TripRepository _repository;

  const GetRunningTripUseCase(this._repository);

  @override
  Future<Either<Failure, RunningTripEntity>> call(NoParams params) {
    return _repository.getRunningTrip();
  }
}
