import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class GetRunningTripUseCase extends UseCase<bool, NoParams> {
  final TripRepository _repository;

  const GetRunningTripUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.getRunningTrip();
  }
}
