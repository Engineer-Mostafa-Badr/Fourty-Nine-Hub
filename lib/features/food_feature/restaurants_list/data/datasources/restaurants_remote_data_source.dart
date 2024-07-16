import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../res/assets/jsons.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../models/food_category_model.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantsRemoteDataSource {
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<RestaurantEntity>>> getSubCategoryRestaurants(
      {required String id});
}

class RestaurantsRemoteDataSourceImpl implements RestaurantsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RestaurantsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories() async {
    final response = await _apiConsumer.get(Jsons.foodCategoriesList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['categories'] as List)
            .map((e) => FoodCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants(
      {required double lat, required double lng}) async {
    final response = await _apiConsumer.get(Jsons.restaurantsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurants'] as List)
            .map((e) => RestaurantModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants(
      {required double lat, required double lng}) async {
    final response = await _apiConsumer.get(Jsons.restaurantsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurants'] as List)
            .map((e) => RestaurantModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<RestaurantEntity>>> getSubCategoryRestaurants(
      {required String id}) async {
    final response =
        await _apiConsumer.get(EndPoints.subCategoryRestaurants(id));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurant'] as List)
            .map((e) => RestaurantModel.fromJson(e))
            .toList()));
  }
}
