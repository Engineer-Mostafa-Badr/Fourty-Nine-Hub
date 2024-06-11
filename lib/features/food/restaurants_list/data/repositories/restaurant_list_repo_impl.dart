import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/food/restaurants_list/data/models/food_category_model.dart';

import 'package:fourtyninehub/features/food/restaurants_list/data/models/restaurant_model.dart';

import '../../domain/repositories/resturant_list_repo.dart';
import '../datasources/restaurants_remote_data_source.dart';

class RestaurantListRepoImpl implements RestaurantListRepo {
  final RestaurantsRemoteDataSource _remoteDataSource;
  RestaurantListRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<FoodCategoryModel>>> getFoodCategories() {
    return _remoteDataSource.getFoodCategories();
  }

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
}
