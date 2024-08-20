import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

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
  Future<Either<Failure, List<FoodOrderEntity>>> getRestaurantOrders() async {
    return await _remoteDataSource.getRestaurantOrders();
  }
}
