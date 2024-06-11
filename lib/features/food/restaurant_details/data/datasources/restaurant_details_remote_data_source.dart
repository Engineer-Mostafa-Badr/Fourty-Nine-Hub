import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food/restaurant_details/data/models/meal_model.dart';
import 'package:fourtyninehub/features/food/restaurants_list/data/models/restaurant_model.dart';

import '../../../../../res/assets/jsons.dart';
import '../models/selected_meal_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<Either<Failure, List<MealModel>>> getMeals(
      {required int restaurantId});
  Future<Either<Failure, RestaurantModel>> getRestaurantDetails(
      {required int restaurantId});
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal});
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final JsonParser _apiConsumer;
  RestaurantRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> addToCart({required SelectedMealModel meal}) {
    // TODO: implement addToCart
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<MealModel>>> getMeals(
      {required int restaurantId}) async {
    final response = await _apiConsumer.get(Jsons.restaurantMeals);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['meals'] as List)
            .map((e) => MealModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, RestaurantModel>> getRestaurantDetails(
      {required int restaurantId}) async{
    final response = await _apiConsumer.get(Jsons.restaurantDetails);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right(RestaurantModel.fromJson(data['data'])));
  }
}
