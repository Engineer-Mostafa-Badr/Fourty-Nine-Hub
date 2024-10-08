import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../../../../res/assets/jsons.dart';
import '../models/food_category_model.dart';
import '../models/restaurant_model.dart';

abstract class RestaurantsRemoteDataSource {
  Future<Either<Failure, bool>> createRestaurant(CreateRestaurantParams params);
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories();
  Future<Either<Failure, List<FoodCategoryModel>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params});
  Future<Either<Failure, List<Restaurant2Model>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params});
  Future<Either<Failure, List<Restaurant2Model>>> searchRestaurants(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params});
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, int>> numOfRestaurants();
  Future<Either<Failure, List<Restaurant2Model>>> getSubCategoryRestaurants(
      {required String id});
  Future<Either<Failure, IsRestaurantModel>> isRestaurant();
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
  Future<Either<Failure, List<Restaurant2Model>>> getSubCategoryRestaurants(
      {required String id}) async {
    final response =
        await _apiConsumer.get(EndPoints.subCategoryRestaurants(id));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['restaurant'] as List)
            .map((e) => Restaurant2Model.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, int>> numOfRestaurants() async {
    final response = await _apiConsumer.get(EndPoints.getNumOfResturants);
    return response.fold(
        (failure) => Left(failure), (data) => Right(data['data'] as int));
  }

  @override
  Future<Either<Failure, IsRestaurantModel>> isRestaurant() async {
    final response = await _apiConsumer.get(EndPoints.isResturant);
    return response.fold((l) => Left(l),
        (data) => Right(IsRestaurantModel.fromMap(data['data'])));
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
    final response = await _apiConsumer.get(
      EndPoints.getAllRestaurantWithMenu(params: params),
    );
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        List.from(
          data["data"].map((e) => Restaurant2Model.fromJson(e)).toList(),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Restaurant2Model>>> searchRestaurants(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params}) async {
    final data = {
      "city": city,
      "subcategoryId": subCategory,
      "government": government
    };
    log("data: ${jsonEncode(data)}");
    final response = await _apiConsumer
        .get(EndPoints.searchRestaurants(params: params), data: data);
    return response.fold(
      (failure) => Left(failure),
      (data) => Right(
        List.from(
          data["data"].map((e) => Restaurant2Model.fromJson(e)).toList(),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> createRestaurant(
      CreateRestaurantParams params) async {
    List<Map<String, dynamic>> mneu = [];
    params.mneu?.forEach((element) {
      final toMap = {
        "foodName": element.foodName,
        "picture": element.photo,
        "price": element.price,
      };
      mneu.add(toMap);
    });
    Map<String, dynamic> data = {
      "name": params.name,
      "subcategoryId": params.subcategoryId,
      "restaurantMedia": params.restaurantMedia,
      "licenseMedia": params.licenseMedia,
      "government": params.government,
      "city": params.city,
      "menu": mneu,
    };

    final response =
        await _apiConsumer.post(EndPoints.createRestaurant, data: data);

    return response.fold(
      (Failure failure) {
        return Left(failure);
      },
      (data) {
        return Right(data['status']);
      },
    );
  }
}
