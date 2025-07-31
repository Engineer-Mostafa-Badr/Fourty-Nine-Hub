import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class StartDriverTripUseCase extends UseCase<bool, StartDriverTripParams> {
  final TripRepository _repository;

  const StartDriverTripUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(StartDriverTripParams params) {
    return _repository.startDriverTrip(params);
  }
}

class StartDriverTripParams{
  final String tripId;
  final String otp;

  StartDriverTripParams({required this.tripId, required this.otp});

  //to json
  Map<String, dynamic> toJson() => {'otp': otp};
}