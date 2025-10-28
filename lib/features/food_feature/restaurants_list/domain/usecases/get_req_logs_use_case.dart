import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_list_repo.dart';

import '../entities/logs_entity.dart';

class GetReqLogsUseCase {
  final RestaurantListRepo _repo;
  GetReqLogsUseCase(this._repo);

  Future<Either<Failure, List<LogsRequestLogsEntity>>> call(
      {required PaginationParams params}) {
    return _repo.getReqLogs(params);
  }
}
