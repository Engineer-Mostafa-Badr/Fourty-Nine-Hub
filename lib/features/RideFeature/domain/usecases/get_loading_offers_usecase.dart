import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../entities/get_offers_entity.dart';

class GetLoadingOffersUsecase {
  final RideRepository repository;

  GetLoadingOffersUsecase(this.repository);

  Future<Either<Failure, GetOffersResponseEntity>> call() async =>
      await repository.getLoadingOffers();
}
