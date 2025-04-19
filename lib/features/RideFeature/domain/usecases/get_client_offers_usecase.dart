import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../entities/get_offers_entity.dart';

class GetClientOffersUsecase {
  final RideRepository repository;

  GetClientOffersUsecase(this.repository);

  Future<Either<Failure, GetOffersResponseEntity>> call() async =>
      await repository.getClientOffers();
}
