import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entity/order_food_entity.dart';
import '../repositories/restaurant_dashboard_repo.dart';

// class GetRestaurantOrdersUseCase
//     extends UseCase<RestaurantOrdersModel, PaginationParams> {
//   final RestaurantDashboardRepo _repository;
//
//   const GetRestaurantOrdersUseCase(this._repository);
//
//   @override
//   Future<Either<Failure, RestaurantOrdersModel>> call(PaginationParams params) {
//     return _repository.getRestaurantOrders(params);
//   }
// }
class GetRestaurantOrdersUseCase
    extends UseCase<GetFoodRequestEntity, PaginationOrderFoodParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, GetFoodRequestEntity>> call(PaginationOrderFoodParams params) {
    return _repository.getRestaurantOrders(params);
  }
}
class PaginationOrderFoodParams {
  int limit;
  int page;
  bool? isCompleted;

  PaginationOrderFoodParams({this.limit = 30, required this.page,this.isCompleted}) {
    if (page < 1 || limit < 1) {
      throw Exception(
          'Invalid pagination params: page and limit must be greater than 0');
    }
  }

  factory PaginationOrderFoodParams.basic() => PaginationOrderFoodParams(page: 1);

  Map<String, dynamic> toJson() => {
    'limit': limit,
    'page': page,
  };
}
