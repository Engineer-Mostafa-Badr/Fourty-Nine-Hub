import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/arrived_to_client_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ArrivedToClientUseCase extends UseCase<bool, ArrivedToClientEntity> {
  final TripRepository _repository;

  const ArrivedToClientUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ArrivedToClientEntity params) {
    return _repository.arrivedToClient(params);
  }
}
