import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../restaurants_list/data/models/restaurant_model.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/selected_meal_model.dart';

abstract class RestaurantDetailsRepo {
   Future<Either<Failure, List<MealModel>>> getMeals(
      {required int restaurantId});
  Future<Either<Failure, RestaurantModel>> getRestaurantDetails(
      {required int restaurantId});
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal});
 
}
