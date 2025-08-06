import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/my_ads_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';
import 'get_car_brand_use_case.dart';

class GetMyAdsTripJoinUseCase
    extends UseCase<MyAdsTripJoinEntity  , CarBrandParams> {
  final ViewAllTripJoinRepo _repo;
  GetMyAdsTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, MyAdsTripJoinEntity>> call(CarBrandParams params) {
    return _repo.getMyAdsTripJoin(params);
  }
}

