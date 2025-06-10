import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/start_ride_trip_usecase.dart';

class CompleteRideTripWithPriceUseCase extends UseCase<bool, CompleteDriverTripWithRemainingMoneyParams> {
  final TripRepository _repository;

  const CompleteRideTripWithPriceUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CompleteDriverTripWithRemainingMoneyParams params) {
    return _repository.completeDriverTripWithRemainingMoney(params);
  }
}

class CompleteDriverTripWithRemainingMoneyParams{
  final String tripId;
  final String remainingMoney;

  CompleteDriverTripWithRemainingMoneyParams({required this.tripId, required this.remainingMoney});

  //toJson
  Map<String, dynamic> toJson() => {"changeHandling": remainingMoney};
}