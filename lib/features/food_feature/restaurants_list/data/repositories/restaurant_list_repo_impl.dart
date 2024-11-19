import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

import '../../domain/repositories/resturant_list_repo.dart';
import '../datasources/restaurants_remote_data_source.dart';
import '../models/restaurant_model.dart';

class RestaurantListRepoImpl implements RestaurantListRepo {
  final RestaurantsRemoteDataSource _remoteDataSource;
  RestaurantListRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants(
      {required double lat, required double lng}) {
    return _remoteDataSource.getNearByReasturants(lat: lat, lng: lng);
  }

  @override
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants(
      {required double lat, required double lng}) {
    return _remoteDataSource.getTrendingRestaurants(lat: lat, lng: lng);
  }

  @override
  Future<Either<Failure, List<Restaurant2Model>>> getSubCategoryRestaurants(
      {required GetSubCategoryRestaurants params}) {
    return _remoteDataSource.getSubCategoryRestaurants(params: params);
  }

  @override
  Future<Either<Failure, int>> numOfRestaurants() {
    return _remoteDataSource.numOfRestaurants();
  }

  @override
  Future<Either<Failure, IsRestaurantModel>> isRestaurant() {
    return _remoteDataSource.isRestaurant();
  }

  @override
  Future<Either<Failure, List<FoodCategoryModel>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params}) {
    return _remoteDataSource.getMealCategoriesWithCountRestaurants(
        params: params);
  }

  @override
  Future<Either<Failure, List<Restaurant2Model>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params}) {
    return _remoteDataSource.getAllRestaurantsWithMenu(params: params);
  }

  @override
  Future<Either<Failure, List<Restaurant2Model>>> searchRestaurants(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params}) {
    return _remoteDataSource.searchRestaurants(
      city: city,
      subCategory: subCategory,
      government: government,
      params: params,
    );
  }

  @override
  Future<Either<Failure, bool>> createRestaurant(
      CreateRestaurantParams params) async {
    return _remoteDataSource.createRestaurant(params);
  }

  @override
  Future<Either<Failure, bool>> changeConnectivity(bool isActive) {
    return _remoteDataSource.changeConnectivity(isActive);
  }

  @override
  Future<Either<Failure, ExpiredRequestsResponse>> getExpiredOrders(
      PaginationParams params) {
    return _remoteDataSource.getExpiredOrders(params);
  }

  @override
  Future<Either<Failure, bool>> toggleRestaurantFavourite({required String params}) {
    return _remoteDataSource.toggleRestaurantFavourite(params:params);
  }
}
