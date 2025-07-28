import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class GoingToClientUseCase extends UseCase<bool, String> {
  final TripRepository _repository;

  const GoingToClientUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.goingToClient(params);
  }
}
