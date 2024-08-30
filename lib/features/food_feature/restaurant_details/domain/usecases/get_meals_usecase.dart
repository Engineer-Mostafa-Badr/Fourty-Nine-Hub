import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import '../../../../../../core/abstract/use_case.dart';

import '../repositories/restaurant_details_repo.dart';

class GetMealsUseCase extends UseCase<List<RestaurantMenu>, String> {
  final RestaurantDetailsRepo _repo;
  GetMealsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RestaurantMenu>>> call(String params) {
    return _repo.getMeals(restaurantId: params);
  }
}
