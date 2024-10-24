import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';


class GetExpiredOrdersUseCase {
  final RestaurantListRepo _repo;
  GetExpiredOrdersUseCase(this._repo);

  Future<Either<Failure, ExpiredRequestsResponse>> call(
      {required PaginationParams params}) {
    return _repo.getExpiredOrders(params);
  }
}
