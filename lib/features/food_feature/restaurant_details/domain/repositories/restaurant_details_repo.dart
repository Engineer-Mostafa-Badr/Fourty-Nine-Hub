import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/add_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/change_quantity_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_from_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

import '../../../../../core/error/failure.dart';

abstract class RestaurantDetailsRepo {
  Future<Either<Failure, List<RestaurantMenu>>> getMeals(
      {required GetMealsParams params});
  Future<Either<Failure, GetAllRestaurantEntity>> getRestaurantDetails(
      {required String restaurantId});
  Future<Either<Failure, bool>> deleteFood({required String id});
  Future<Either<Failure, bool>> changeQuantity(
      {required ChangeQuantityParams params});
  Future<Either<Failure, bool>> deleteFoodFromCart(
      {required DeleteFoodFromCartParams params});
  Future<Either<Failure, bool>> deleteCart();
  Future<Either<Failure, RestaurantMenu>> addFood(
      {required AddFoodParams params});
  Future<Either<Failure, bool>> addToCart({
    required String restaurantId,
    required String foodId,
    required int quantity,
  });
}
