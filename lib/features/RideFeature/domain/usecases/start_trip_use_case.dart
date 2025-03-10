import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

class StartTripUseCase {
  final RideRepository repository;

  StartTripUseCase(this.repository);
  Future<Either<Failure, bool>> call(StartTripUseCaseParams params) async {
    return repository.startTrip(params);
  }
}

class StartTripUseCaseParams {
  final String tripId;
  final String otp;

  StartTripUseCaseParams({required this.tripId, required this.otp});

  toJson() => {'OTP': otp};
}