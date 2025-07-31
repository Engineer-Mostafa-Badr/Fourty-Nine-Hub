import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repos/view_all_trip_join_repo.dart';
import 'get_car_brand_use_case.dart';

class GetCarModelUseCase
    extends UseCase<List<RideModelEntity>, CarBrandParams> {
  final ViewAllTripJoinRepo _repo;
  GetCarModelUseCase(this._repo);

  @override
  Future<Either<Failure, List<RideModelEntity>>> call(CarBrandParams params) {
    return _repo.getRideModels(params);
  }
}

