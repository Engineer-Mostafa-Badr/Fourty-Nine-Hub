import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/add_food_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/change_quantity_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/delete_food_from_cart_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/usecases/get_meals_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_mneu_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

abstract class RestaurantRemoteDataSource {
  Future<Either<Failure, List<RestaurantMneuModel>>> getMeals(
      {required GetMealsParams params});
  Future<Either<Failure, Restaurant2Model>> getRestaurantDetails(
      {required String restaurantId});
  Future<Either<Failure, bool>> deleteFood({required String id});
  Future<Either<Failure, RestaurantMenu>> addFood(
      {required AddFoodParams params});
  Future<Either<Failure, bool>> addCart();
  Future<Either<Failure, bool>> deleteFoodFromCart(
      {required DeleteFoodFromCartParams params});
  Future<Either<Failure, bool>> changeQuantity(
      {required ChangeQuantityParams params});
  Future<Either<Failure, bool>> addToCart({
    required String restaurantId,
    required String foodId,
    required int quantity,
  });
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RestaurantRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> addToCart(
      {required String restaurantId,
      required String foodId,
      required int quantity}) async {
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
      {required GetMealsParams params}) async {
    final response = await _apiConsumer.get(EndPoints.restaurantMeals(params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['items'] as List)
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

  @override
  Future<Either<Failure, bool>> deleteFood({required String id}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteFood(id));
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, RestaurantMenu>> addFood(
      {required AddFoodParams params}) async {
    final response =
        await _apiConsumer.post(EndPoints.addFood,data: params.toJson(),
        queryParameters: {"subCategory": params.subcategory}
        );
    return response.fold((failure) => Left(failure),
        (data) => Right(RestaurantMneuModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> addCart() async {
    final response = await _apiConsumer.delete(EndPoints.deleteCart);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteFoodFromCart(
      {required DeleteFoodFromCartParams params}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteFoodFromCart,
        data: params.toJson());
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> changeQuantity(
      {required ChangeQuantityParams params}) async {
    final response = await _apiConsumer.put(EndPoints.changeFoodQuantity,
        data: params.toJson());
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['status']));
  }
}
