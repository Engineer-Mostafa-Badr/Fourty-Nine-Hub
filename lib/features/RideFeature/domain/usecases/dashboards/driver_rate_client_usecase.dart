import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/running_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class DriverRateClientUseCase extends UseCase<bool, DriverRateClientParams> {
  final TripRepository _repository;

  const DriverRateClientUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(DriverRateClientParams params) {
    return _repository.driverRateClient(params);
  }
}

class DriverRateClientParams{
  final String tripId;
  final double rate;
  final String comment;

  DriverRateClientParams({required this.tripId, required this.rate, required this.comment});

  //toJson
  Map<String, dynamic> toJson() => {"tripId": tripId, "ratingValue": rate, "comment": comment};
}