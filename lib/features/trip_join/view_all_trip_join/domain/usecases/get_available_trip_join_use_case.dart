import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/available_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';
import 'get_car_brand_use_case.dart';

class GetAvailableTripJoinUseCase
    extends UseCase<List<AvailableTripJoinEntity>, CarBrandParams> {
  final ViewAllTripJoinRepo _repo;
  GetAvailableTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, List<AvailableTripJoinEntity>>> call(CarBrandParams params) {
    return _repo.getAvailableTripJoin(params);
  }
}

