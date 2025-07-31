import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

import '../entities/logs_entity.dart';

class GetReqLogsUseCase {
  final RestaurantListRepo _repo;
  GetReqLogsUseCase(this._repo);

  Future<Either<Failure, List<LogsRequestLogsEntity>>> call(
      {required PaginationParams params}) {
    return _repo.getReqLogs(params);
  }
}
