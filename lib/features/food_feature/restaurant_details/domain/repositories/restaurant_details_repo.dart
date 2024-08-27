import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

import '../../../../../core/error/failure.dart';
import '../../data/models/selected_meal_model.dart';

abstract class RestaurantDetailsRepo {
  Future<Either<Failure, List<RestaurantMenu>>> getMeals(
      {required String restaurantId});
  Future<Either<Failure, Restaurant>> getRestaurantDetails(
      {required String restaurantId});
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal});
}
