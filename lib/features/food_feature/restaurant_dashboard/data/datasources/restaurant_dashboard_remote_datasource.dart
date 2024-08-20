import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../../../../../res/assets/jsons.dart';
import '../../../../requests_history/data/models/food_order_model.dart';

abstract class RestaurantDashboardRemoteDataSource {
  Future<Either<Failure, List<FoodOrderEntity>>> getRestaurantOrders();
  Future<Either<Failure, bool>> changeActiveStatus();
  Future<Either<Failure, bool>> cancelOrder({required int id});
  Future<Either<Failure, bool>> approveOrder({required int id});
}

class RestaurantDashboardRemoteDataSourceImpl
    implements RestaurantDashboardRemoteDataSource {
  final JsonParser _apiConsumer;
  RestaurantDashboardRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> approveOrder({required int id}) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> cancelOrder({required int id}) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, bool>> changeActiveStatus() async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, List<FoodOrderEntity>>> getRestaurantOrders() async {
    final response = await _apiConsumer.get(Jsons.foodOrders);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['orders'] as List)
            .map((e) => FoodOrderModel.fromJson(e))
            .toList()));
  }
}
