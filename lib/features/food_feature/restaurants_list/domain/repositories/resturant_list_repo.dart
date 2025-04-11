import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/create_restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/getsubcategory_restaurants_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../data/models/restaurant_model.dart';
import '../entities/logs_entity.dart';
import '../entities/rate_response_entity.dart';
import '../entities/user_order_entity.dart';
import '../usecases/add_rate_restaurant_use_case.dart';
import '../usecases/get_user_order_use_case.dart';

abstract class RestaurantListRepo {
  Future<Either<Failure, List<RestaurantModel>>> getNearByReasturants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<Restaurant2Model>>> getAllRestaurantsWithMenu(
      {required PostCommentsParams params});
  Future<Either<Failure, IsRestaurantModel>> isRestaurant();

  Future<Either<Failure, int>> numOfRestaurants();
  Future<Either<Failure, bool>> changeConnectivity(bool isActive);
  Future<Either<Failure, bool>> toggleRestaurantFavourite(
      {required String params});
  Future<Either<Failure, ExpiredRequestsResponse>> getExpiredOrders(
      PaginationParams params);

  Future<Either<Failure, List<LogsRequestLogsEntity>>> getReqLogs(
      PaginationParams params);

  Future<Either<Failure, List<RestaurantModel>>> getTrendingRestaurants({
    required double lat,
    required double lng,
  });
  Future<Either<Failure, List<Restaurant2Model>>> getSubCategoryRestaurants(
      {required GetSubCategoryRestaurants params});
  Future<Either<Failure, List<FoodCategoryEntity>>>
      getMealCategoriesWithCountRestaurants(
          {required PostCommentsParams params});
  Future<Either<Failure, List<Restaurant2Model>>> searchRestaurants(
      {required String city,
      required String subCategory,
      required String government,
      PostCommentsParams? params});
  Future<Either<Failure, bool>> createRestaurant(CreateRestaurantParams params);

  Future<Either<Failure, List<UserOrderEntity>>> getUserOrder({required GetUserOrderParams params});

  Future<Either<Failure, RateResponseEntity>> addRateRestaurant({required AddRateRestaurantParams params});
}
