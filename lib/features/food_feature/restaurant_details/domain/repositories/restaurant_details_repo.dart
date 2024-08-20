import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';

import '../../../restaurants_list/domain/entities/restaurant_entity.dart';

import '../../data/models/selected_meal_model.dart';
import '../entities/meal_entity.dart';

abstract class RestaurantDetailsRepo {
  Future<Either<Failure, List<MealEntity>>> getMeals(
      {required String restaurantId});
  Future<Either<Failure, RestaurantEntity>> getRestaurantDetails(
      {required String restaurantId});
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal});
}
