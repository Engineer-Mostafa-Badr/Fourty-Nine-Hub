import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../RideFeature/domain/entities/ride_brand_entity.dart';
import '../entities/available_trip_join_entity.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';
import 'delete_my_trip_join_use_case.dart';
import 'get_car_brand_use_case.dart';

class ApplyViewTripJoinUseCase
    extends UseCase<DeleteMyTripJoinEntity , DeleteMyTripParams> {
  final ViewAllTripJoinRepo _repo;
  ApplyViewTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity >> call(DeleteMyTripParams params) {
    return _repo.applyViewTripJoin(params);
  }
}
