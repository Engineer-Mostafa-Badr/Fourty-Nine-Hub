import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/food/restaurant_details/data/models/meal_model.dart';

import 'package:fourtyninehub/features/food/restaurant_details/data/models/selected_meal_model.dart';

import 'package:fourtyninehub/features/food/restaurants_list/data/models/restaurant_model.dart';

import '../../domain/repositories/restaurant_details_repo.dart';
import '../datasources/restaurant_details_remote_data_source.dart';

class RestaurantDetailsRepoImpl implements RestaurantDetailsRepo {
  final RestaurantRemoteDataSource _remoteDataSource;
  RestaurantDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal}) {
    return _remoteDataSource.addToCart(meal: meal);
  }

  @override
  Future<Either<Failure, List<MealModel>>> getMeals(
      {required int restaurantId}) {
    return _remoteDataSource.getMeals(restaurantId: restaurantId);
  }

  @override
  Future<Either<Failure, RestaurantModel>> getRestaurantDetails(
      {required int restaurantId}) {
    return _remoteDataSource.getRestaurantDetails(restaurantId: restaurantId);
  }
}
