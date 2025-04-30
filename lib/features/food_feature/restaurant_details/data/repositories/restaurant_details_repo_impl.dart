import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/add_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/change_quantity_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_from_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_details_repo.dart';
import '../datasources/restaurant_details_remote_data_source.dart';

class RestaurantDetailsRepoImpl implements RestaurantDetailsRepo {
  final RestaurantRemoteDataSource _remoteDataSource;
  RestaurantDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> addToCart({
    required String restaurantId,
    required String foodId,
    required int quantity,
  }) {
    return _remoteDataSource.addToCart(
      restaurantId: restaurantId,
      foodId: foodId,
      quantity: quantity,
    );
  }

  @override
  Future<Either<Failure, List<RestaurantMneuModel>>> getMeals(
      {required GetMealsParams params}) {
    return _remoteDataSource.getMeals(params: params);
  }

  @override
  Future<Either<Failure, GetAllRestaurantEntity>> getRestaurantDetails(
      {required String restaurantId}) {
    return _remoteDataSource.getRestaurantDetails(restaurantId: restaurantId);
  }

  @override
  Future<Either<Failure, bool>> deleteFood({required String id}) {
    return _remoteDataSource.deleteFood(id: id);
  }

  @override
  Future<Either<Failure, RestaurantMenu>> addFood(
      {required AddFoodParams params}) {
    return _remoteDataSource.addFood(params: params);
  }

  @override
  Future<Either<Failure, bool>> deleteCart() {
    return _remoteDataSource.addCart();
  }

  @override
  Future<Either<Failure, bool>> deleteFoodFromCart(
      {required DeleteFoodFromCartParams params}) {
    return _remoteDataSource.deleteFoodFromCart(params: params);
  }

  @override
  Future<Either<Failure, bool>> changeQuantity(
      {required ChangeQuantityParams params}) {
    return _remoteDataSource.changeQuantity(params: params);
  }
}
