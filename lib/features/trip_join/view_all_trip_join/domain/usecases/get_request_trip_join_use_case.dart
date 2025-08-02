import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/request_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';
import 'get_car_brand_use_case.dart';

class GetRequestTripJoinUseCase
    extends UseCase<List<GetRequestTripJoinEntity> , CarBrandParams> {
  final ViewAllTripJoinRepo _repo;
  GetRequestTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetRequestTripJoinEntity> >> call(CarBrandParams params) {
    return _repo.getRequestTripJoin(params);
  }
}

