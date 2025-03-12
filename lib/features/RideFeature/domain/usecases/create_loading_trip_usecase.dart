import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';

import '../../data/models/create_loading_trip_model.dart';
import '../entities/create_loading_trip_entity.dart';

class CreateLoadingTripUseCase
    extends UseCase<CreateLoadingTripEntity, CreateLoadingTripModel> {
  final ShippingRepository _repo;

  CreateLoadingTripUseCase(this._repo);

  @override
  Future<Either<Failure, CreateLoadingTripEntity>> call(
      CreateLoadingTripModel params) {
    return _repo.createLoadingTrip(params);
  }
}
