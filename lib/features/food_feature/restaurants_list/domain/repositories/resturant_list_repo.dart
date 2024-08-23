import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

import '../../../../../core/error/failure.dart';

import '../../data/models/restaurant_model.dart';
import '../entities/restaurant_entity.dart';

abstract class RestaurantListRepo {
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<Restaurant>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params});
  Future<Either<Failure, bool>> isRestaurant();

  Future<Either<Failure, int>> numOfRestaurants();
  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<RestaurantEntity>>> getSubCategoryRestaurants(
      {required String id});
  Future<Either<Failure, List<FoodCategoryEntity>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params});
}
