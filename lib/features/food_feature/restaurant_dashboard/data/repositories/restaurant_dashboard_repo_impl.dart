import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/entity/complete_order_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/complete_order_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/delete_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';

import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../domain/entity/order_food_entity.dart';
import '../../domain/repositories/restaurant_dashboard_repo.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';
import '../datasources/restaurant_dashboard_remote_datasource.dart';

class RestaurantDashboardRepoImpl implements RestaurantDashboardRepo {
  final RestaurantDashboardRemoteDataSource _remoteDataSource;
  RestaurantDashboardRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> approveOrder({required int id}) async {
    return await _remoteDataSource.approveOrder(id: id);
  }

  @override
  Future<Either<Failure, bool>> cancelOrder({required int id}) async {
    return await _remoteDataSource.cancelOrder(id: id);
  }

  @override
  Future<Either<Failure, bool>> changeActiveStatus() async {
    return await _remoteDataSource.changeActiveStatus();
  }

  @override
  Future<Either<Failure, GetFoodRequestEntity>> getRestaurantOrders(
      PaginationOrderFoodParams params) async {
    return await _remoteDataSource.getRestaurantOrders(params);
  }

  @override
  Future<Either<Failure, GetAllRestaurantEntity>> getRestaurantInfo() async {
    return await _remoteDataSource.getRestaurantInfo();
  }

  @override
  Future<Either<Failure, RestaurantStatistics>>
      getRestaurantStatistics() async {
    return await _remoteDataSource.getRestaurantStatistics();
  }

  @override
  Future<Either<Failure, bool>> deleteRestaurant(
      DeleteResturantParams restaurantId) async {
    return await _remoteDataSource.deleteRestaurant(restaurantId);
  }

  @override
  Future<Either<Failure, bool>> updateRestaurant(
      UpdateRestaurantParams params) async {
    return await _remoteDataSource.updateRestaurant(params);
  }

  @override
  Future<Either<Failure, CompleteOrderEntity>> completeOrder({required CompleteOrderParams params})async {
    return await _remoteDataSource.completeOrder(params:params);  }
}
