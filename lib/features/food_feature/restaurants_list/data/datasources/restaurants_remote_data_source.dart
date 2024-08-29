import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../res/assets/jsons.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../models/food_category_model.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantsRemoteDataSource {
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories();
  Future<Either<Failure, List<FoodCategoryModel>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params});
  Future<Either<Failure, List<Restaurant2Model>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params});
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, int>> numOfRestaurants();
  Future<Either<Failure, List<RestaurantEntity>>> getSubCategoryRestaurants(
      {required String id});
  Future<Either<Failure, bool>> isRestaurant();
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

  @override
  Future<Either<Failure, int>> numOfRestaurants() async {
    final response = await _apiConsumer.get(EndPoints.getNumOfResturants);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['data'] as int));
  }

  @override
  Future<Either<Failure, bool>> isRestaurant() async {
    final response = await _apiConsumer.get(EndPoints.isResturant);
    return response.fold(
        (l) => Left(l), (data) => Right(data['data']['isRestaurant'] as bool));
  }

  @override
  Future<Either<Failure, List<FoodCategoryModel>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params}) async {
    final response = await _apiConsumer
        .get(EndPoints.getMealsWithCountRestaurant(params: params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['subCategories'] as List)
            .map((e) => FoodCategoryModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<Restaurant2Model>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params}) async {
    final response = await _apiConsumer
        .get(EndPoints.getAllRestaurantWithMenu(params: params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right(List<Restaurant2Model>.from(
            data["data"].map((e) => Restaurant2Model.fromJson(e)).toList)));
  }
}
