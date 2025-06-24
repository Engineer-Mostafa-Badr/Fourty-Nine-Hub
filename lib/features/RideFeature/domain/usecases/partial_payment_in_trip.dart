import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class PartialPaymentInTripUseCase {
  final RideRepository repository;
  PartialPaymentInTripUseCase(this.repository);
  Future<Either<Failure, bool>> call(PartialPaymentInTripUseCaseParams params) async => await repository.partialPaymentInTrip(params);
}
class PartialPaymentInTripUseCaseParams {
  final String tripId;
  final double amount;
  final String paymentMethod;
  PartialPaymentInTripUseCaseParams({required this.tripId, required this.amount, required this.paymentMethod});

  toJson() => {'amount': amount.toInt(), 'paymentMethod': 'wallet'};
}