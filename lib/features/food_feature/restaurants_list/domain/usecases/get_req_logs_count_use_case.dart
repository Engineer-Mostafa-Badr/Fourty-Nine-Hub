import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_list_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../entities/log_count_entity.dart';


class GetReqLogsCountUseCase extends UseCase<RequestLogCountEntity , NoParams> {
  final RestaurantListRepo _repo;

  GetReqLogsCountUseCase(this._repo);
  @override
  Future<Either<Failure, RequestLogCountEntity>> call(NoParams params) async {
    return await _repo.getReqCount();
  }

}
