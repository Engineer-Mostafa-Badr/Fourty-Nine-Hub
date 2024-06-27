import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/domain/entities/food_order_entity.dart';

abstract class RestaurantDashboardRepo {
  Future<Either<Failure, List<FoodOrderEntity>>> getRestaurantOrders();
  Future<Either<Failure, bool>> changeActiveStatus();
  Future<Either<Failure, bool>> cancelOrder({required int id});
  Future<Either<Failure, bool>> approveOrder({required int id});
}