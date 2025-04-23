import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../entities/log_count_entity.dart';
import '../entities/logs_entity.dart';


class GetReqLogsCountUseCase extends UseCase<RequestLogCountEntity , NoParams> {
  final RestaurantListRepo _repo;

  GetReqLogsCountUseCase(this._repo);
  @override
  Future<Either<Failure, RequestLogCountEntity>> call(NoParams params) async {
    return await _repo.getReqCount();
  }

}
