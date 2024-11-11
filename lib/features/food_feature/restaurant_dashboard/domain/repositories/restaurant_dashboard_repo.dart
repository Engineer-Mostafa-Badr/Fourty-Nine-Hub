import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/domain/entities/food_order_entity.dart';

abstract class RestaurantDashboardRepo {
  Future<Either<Failure, RestaurantOrdersModel>> getRestaurantOrders(PaginationParams params);
  Future<Either<Failure, Restaurant2Model>> getRestaurantInfo();
  Future<Either<Failure, bool>> deleteRestaurant(String restaurantId);
  Future<Either<Failure, bool>> updateRestaurant(UpdateRestaurantParams params);
  Future<Either<Failure, RestaurantStatistics>> getRestaurantStatistics();
  Future<Either<Failure, bool>> changeActiveStatus();
  Future<Either<Failure, bool>> cancelOrder({required int id});
  Future<Either<Failure, bool>> approveOrder({required int id});
}
