import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';

class CompleteDriverTripUseCase extends UseCase<bool, StartDriverTripParams> {
  final TripRepository _repository;

  const CompleteDriverTripUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(StartDriverTripParams params) {
    return _repository.completeDriverTrip(params);
  }
}