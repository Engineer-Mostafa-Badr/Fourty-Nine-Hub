import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';

import '../../../../../core/api/end_points.dart';

abstract class RestaurantRemoteDataSource {
  Future<Either<Failure, List<RestaurantMneuModel>>> getMeals(
      {required String restaurantId});
  Future<Either<Failure, Restaurant2Model>> getRestaurantDetails(
      {required String restaurantId});
  Future<Either<Failure, bool>> addToCart({
    required String restaurantId,
    required String foodId,
    required String quantity,
  });
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RestaurantRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> addToCart(
      {required String restaurantId,
      required String foodId,
      required String quantity}) async {
    final data = {
      'restaurantId': restaurantId,
      'restaurantItem': {
        'foodId': foodId,
        'quantity': quantity,
      },
    };
    final response = await _apiConsumer.post(EndPoints.addToCart, data: data);
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, List<RestaurantMneuModel>>> getMeals(
      {required String restaurantId}) async {
    final response =
        await _apiConsumer.get(EndPoints.restaurantMeals(restaurantId));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => RestaurantMneuModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, Restaurant2Model>> getRestaurantDetails(
      {required String restaurantId}) async {
    final response =
        await _apiConsumer.get(EndPoints.restaurantDetails(restaurantId));
    return response.fold((failure) => Left(failure),
        (data) => Right(Restaurant2Model.fromJson(data['data']['restaurant'])));
  }
}
