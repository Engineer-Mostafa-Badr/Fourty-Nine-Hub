import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/loading/create_rate_with_driver_loading_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/rate_response_entity.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';

class CreateRateWithClientLoadingUseCase extends UseCase<RateResponseEntity , AddRateWithDriverLoadingParams> {
  final TripRepository _repo;
  CreateRateWithClientLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, RateResponseEntity >> call(AddRateWithDriverLoadingParams params) {
    return _repo.addRateWithClientLoading(params);
  }
}