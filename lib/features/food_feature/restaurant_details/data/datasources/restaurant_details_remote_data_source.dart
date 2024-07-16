import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';

import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../core/api/end_points.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../restaurants_list/data/models/restaurant_model.dart';
import '../../../restaurants_list/domain/entities/restaurant_entity.dart';
import '../../domain/entities/meal_entity.dart';
import '../models/meal_model.dart';
import '../models/selected_meal_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<Either<Failure, List<MealEntity>>> getMeals(
      {required String restaurantId});
  Future<Either<Failure, RestaurantEntity>> getRestaurantDetails(
      {required String restaurantId});
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal});
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RestaurantRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> addToCart(
      {required SelectedMealModel meal}) async {
    final response =
        await _apiConsumer.post(EndPoints.addToCart, data: meal.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals(
      {required String restaurantId}) async {
    final response =
        await _apiConsumer.get(EndPoints.restaurantMeals(restaurantId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right(
            (data['data'] as List).map((e) => MealModel.fromJson(e)).toList()));
  }

  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantDetails(
      {required String restaurantId}) async {
    final response =
        await _apiConsumer.get(EndPoints.restaurantDetails(restaurantId));
    return response.fold((failure) => Left(failure),
        (data) => Right(RestaurantModel.fromJson(data['data']['restaurant'])));
  }
}
