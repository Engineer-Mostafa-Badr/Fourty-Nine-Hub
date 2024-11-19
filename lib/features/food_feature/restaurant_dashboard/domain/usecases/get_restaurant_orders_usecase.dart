import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class GetRestaurantOrdersUseCase
    extends UseCase<RestaurantOrdersModel, PaginationParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, RestaurantOrdersModel>> call(PaginationParams params) {
    return _repository.getRestaurantOrders(params);
  }
}
