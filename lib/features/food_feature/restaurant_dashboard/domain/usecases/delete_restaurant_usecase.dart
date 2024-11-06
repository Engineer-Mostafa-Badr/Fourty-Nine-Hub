import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class DeleteRestaurantUseCase
    extends UseCase<bool, String> {
  final RestaurantDashboardRepo _repository;

  const DeleteRestaurantUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.deleteRestaurant(params);
  }
}
