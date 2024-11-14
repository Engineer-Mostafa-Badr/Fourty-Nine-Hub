import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class GetRestaurantStatisticUseCase
    extends UseCase<RestaurantStatistics, NoParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantStatisticUseCase(this._repository);

  @override
  Future<Either<Failure, RestaurantStatistics>> call(NoParams params) {
    return _repository.getRestaurantStatistics();
  }
}
