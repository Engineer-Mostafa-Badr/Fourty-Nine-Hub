import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/data/models/restaurant_orders_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/update_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/entities/food_order_entity.dart';

import '../../../../../res/assets/jsons.dart';
import '../../../../requests_history/data/models/food_order_model.dart';

abstract class RestaurantDashboardRemoteDataSource {
  Future<Either<Failure, RestaurantOrdersModel>> getRestaurantOrders(PaginationParams params);
  Future<Either<Failure, bool>> changeActiveStatus();
  Future<Either<Failure, bool>> deleteRestaurant(String restaurantId);
  Future<Either<Failure, bool>> updateRestaurant(UpdateRestaurantParams params);
  Future<Either<Failure, Restaurant2Model>> getRestaurantInfo();
  Future<Either<Failure, RestaurantStatistics>> getRestaurantStatistics();
  Future<Either<Failure, bool>> cancelOrder({required int id});
  Future<Either<Failure, bool>> approveOrder({required int id});
}

class RestaurantDashboardRemoteDataSourceImpl
    implements RestaurantDashboardRemoteDataSource {
  final JsonParser _apiConsumer;
  final ApiConsumer _apiServices;
  RestaurantDashboardRemoteDataSourceImpl(this._apiConsumer, this._apiServices);
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
  Future<Either<Failure, RestaurantOrdersModel>> getRestaurantOrders(PaginationParams params) async {
    final response = await _apiServices.get(EndPoints.getRestaurantOrders(params));
    return response.fold(
        (failure) => Left(failure),
        (data) => Right(RestaurantOrdersModel.fromJson(data)));
  }

  @override
  Future<Either<Failure, Restaurant2Model>> getRestaurantInfo() async {
    final response = await _apiServices.get(EndPoints.getRestaurantInfo);

    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(Restaurant2Model.fromJson(data['data']));
    });
  }

  @override
  Future<Either<Failure, RestaurantStatistics>> getRestaurantStatistics() async {
    final response = await _apiServices.get(EndPoints.getRestaurantStatistics);
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(RestaurantStatistics.fromJson(data));
    });
  }

  @override
  Future<Either<Failure, bool>> deleteRestaurant(String restaurantId) async{
    final response = await _apiServices.delete(EndPoints.deleteRestaurant(restaurantId));
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(data['status']);
    });  }

  @override
  Future<Either<Failure, bool>> updateRestaurant(params) async {
    final response = await _apiServices.put(EndPoints.updateRestaurant,data: params.toJson());
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(data['status']);
    });
  }
}
