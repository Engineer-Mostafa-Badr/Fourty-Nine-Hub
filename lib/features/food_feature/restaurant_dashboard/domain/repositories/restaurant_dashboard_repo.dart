import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/delete_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../entity/complete_order_entity.dart';
import '../entity/order_food_entity.dart';
import '../usecases/complete_order_restaurant_usecase.dart';
import '../usecases/get_restaurant_orders_usecase.dart';

abstract class RestaurantDashboardRepo {
  Future<Either<Failure, GetFoodRequestEntity>> getRestaurantOrders(
      PaginationOrderFoodParams params);
  Future<Either<Failure, GetAllRestaurantEntity>> getRestaurantInfo();
  Future<Either<Failure, bool>> deleteRestaurant(
      DeleteResturantParams restaurantId);
  Future<Either<Failure, bool>> updateRestaurant(UpdateRestaurantParams params);
  Future<Either<Failure, RestaurantStatistics>> getRestaurantStatistics();
  Future<Either<Failure, bool>> changeActiveStatus();
  Future<Either<Failure, bool>> cancelOrder({required int id});
  Future<Either<Failure, bool>> approveOrder({required int id});
  Future<Either<Failure, CompleteOrderEntity>> completeOrder({required CompleteOrderParams params});
}
