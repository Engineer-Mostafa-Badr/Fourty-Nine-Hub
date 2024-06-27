import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class GetRestaurantOrdersUseCase
    extends UseCase<List<FoodOrderEntity>, NoParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantOrdersUseCase(this._repository);

  @override
  Future<Either<Failure, List<FoodOrderEntity>>> call(NoParams params) {
    return _repository.getRestaurantOrders();
  }
}
