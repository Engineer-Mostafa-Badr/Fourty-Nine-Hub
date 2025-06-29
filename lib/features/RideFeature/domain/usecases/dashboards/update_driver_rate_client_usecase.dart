import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/driver_rate_client_usecase.dart';

class UpdateDriverRateClientUseCase extends UseCase<bool, DriverRateClientParams> {
  final TripRepository _repository;

  const UpdateDriverRateClientUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(DriverRateClientParams params) {
    return _repository.updateDriverRateClient(params);
  }
}
