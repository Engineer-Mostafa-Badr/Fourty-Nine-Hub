import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/get_request_count_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class GetRequestCountPickMeUseCase
    extends UseCase<GetRequestCountEntity, NoParams> {
  final ViewAllTripJoinRepo _repo;
  GetRequestCountPickMeUseCase(this._repo);

  @override
  Future<Either<Failure, GetRequestCountEntity>> call(NoParams params) {
    return _repo.getRequestCountPickMe();
  }
}


