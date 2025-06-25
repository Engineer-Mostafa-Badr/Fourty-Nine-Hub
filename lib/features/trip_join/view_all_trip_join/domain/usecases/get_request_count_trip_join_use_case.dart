import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/domain/entity/expected_price_entity.dart';
import '../entities/expected_price_entity.dart';
import '../entities/get_request_count_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class GetRequestCountTripJoinUseCase
    extends UseCase<GetRequestCountEntity, NoParams> {
  final ViewAllTripJoinRepo _repo;
  GetRequestCountTripJoinUseCase(this._repo);

  @override
  Future<Either<Failure, GetRequestCountEntity>> call(NoParams params) {
    return _repo.getRequestCountTripJoin();
  }
}


