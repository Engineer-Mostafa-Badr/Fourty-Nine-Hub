
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class UpdateTripPriceUseCase {
  final RideRepository repository;

  UpdateTripPriceUseCase(this.repository);

  Future<Either<Failure, bool>> call(UpdateTripPriceUseCaseParams params) {
    return repository.updateTripPrice(params);
  }
}

class UpdateTripPriceUseCaseParams {
  final double newOfferPrice;

  UpdateTripPriceUseCaseParams({
    required this.newOfferPrice,
  });
  toJson() => {'increasedPrice': newOfferPrice};
}