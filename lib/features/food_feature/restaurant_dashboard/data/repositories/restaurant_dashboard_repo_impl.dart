import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/delete_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';

import '../../domain/repositories/restaurant_dashboard_repo.dart';
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
  Future<Either<Failure, RestaurantOrdersModel>> getRestaurantOrders(
      PaginationParams params) async {
    return await _remoteDataSource.getRestaurantOrders(params);
  }

  @override
  Future<Either<Failure, Restaurant2Model>> getRestaurantInfo() async {
    return await _remoteDataSource.getRestaurantInfo();
  }

  @override
  Future<Either<Failure, RestaurantStatistics>>
      getRestaurantStatistics() async {
    return await _remoteDataSource.getRestaurantStatistics();
  }

  @override
  Future<Either<Failure, bool>> deleteRestaurant(DeleteResturantParams restaurantId) async {
    return await _remoteDataSource.deleteRestaurant(restaurantId);
  }

  @override
  Future<Either<Failure, bool>> updateRestaurant(
      UpdateRestaurantParams params) async {
    return await _remoteDataSource.updateRestaurant(params);
  }
}
