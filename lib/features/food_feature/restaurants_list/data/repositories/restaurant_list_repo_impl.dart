import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/food_category_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_entity.dart';
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
  Future<Either<Failure, List<RestaurantEntity>>> getSubCategoryRestaurants(
      {required String id}) {
    return _remoteDataSource.getSubCategoryRestaurants(id: id);
  }

  @override
  Future<Either<Failure, int>> numOfRestaurants() {
    return _remoteDataSource.numOfRestaurants();
  }

  @override
  Future<Either<Failure, bool>> isRestaurant() {
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
  Future<Either<Failure, List<Restaurant>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params}) {
    return _remoteDataSource.getAllRestaurantsWithMenu(params: params);
  }
}
