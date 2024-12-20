import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class GetRestaurantInfoUseCase extends UseCase<Restaurant2Model, NoParams> {
  final RestaurantDashboardRepo _repository;

  const GetRestaurantInfoUseCase(this._repository);

  @override
  Future<Either<Failure, Restaurant2Model>> call(NoParams params) {
    return _repository.getRestaurantInfo();
  }
}
