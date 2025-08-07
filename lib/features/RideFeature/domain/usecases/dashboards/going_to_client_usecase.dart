import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class GoingToClientUseCase extends UseCase<RunningTripEntity, String> {
  final TripRepository _repository;

  const GoingToClientUseCase(this._repository);

  @override
  Future<Either<Failure, RunningTripEntity>> call(String params) {
    return _repository.goingToClient(params);
  }
}
