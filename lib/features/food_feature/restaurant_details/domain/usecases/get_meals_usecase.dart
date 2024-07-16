import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/entities/meal_entity.dart';
import '../../../../../../core/abstract/use_case.dart';

import '../repositories/restaurant_details_repo.dart';

class GetMealsUseCase
    extends UseCase<List<MealEntity>, String> {
  final RestaurantDetailsRepo _repo;
  GetMealsUseCase(this._repo);

  @override
  Future<Either<Failure, List<MealEntity>>> call(String params) {
    return _repo.getMeals(restaurantId: params);
  }
}
