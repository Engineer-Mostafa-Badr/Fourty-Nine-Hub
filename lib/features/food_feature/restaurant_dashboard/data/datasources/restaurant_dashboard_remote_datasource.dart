import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/json_parser.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/update_restaurant_usecase.dart';
import '../../presentation/cubit/restaurant_statistics_cubit.dart';
import '../../../restaurants_list/data/models/restaurant_2_model.dart';

import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../domain/entity/complete_order_entity.dart';
import '../../domain/entity/order_food_entity.dart';
import '../../domain/usecases/complete_order_restaurant_usecase.dart';
import '../../domain/usecases/delete_restaurant_usecase.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';
import '../models/complete_order_model.dart';
import '../models/order_food_model.dart';

abstract class RestaurantDashboardRemoteDataSource {
  Future<Either<Failure, GetFoodRequestEntity>> getRestaurantOrders(
      PaginationOrderFoodParams params);
  Future<Either<Failure, bool>> changeActiveStatus();
  Future<Either<Failure, bool>> deleteRestaurant(DeleteResturantParams params);
  Future<Either<Failure, bool>> updateRestaurant(UpdateRestaurantParams params);
  Future<Either<Failure, GetAllRestaurantEntity>> getRestaurantInfo();
  Future<Either<Failure, RestaurantStatistics>> getRestaurantStatistics();
  Future<Either<Failure, bool>> cancelOrder({required int id});
  Future<Either<Failure, bool>> approveOrder({required int id});
  Future<Either<Failure, CompleteOrderEntity>> completeOrder({required CompleteOrderParams params});

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
  void debugApiResponse(dynamic data) {
    print("API Response: ${data.toString()}");
  }
  @override
  Future<Either<Failure, GetFoodRequestEntity>> getRestaurantOrders(
      PaginationOrderFoodParams params) async {
    final response = await _apiServices.get(EndPoints.getRestaurantOrders(params));

    return response.fold(
          (failure) {
        print("API Call Failed: ${failure.toString()}");
        return Left(failure);
      },
          (data) {
        debugApiResponse(data);
        return Right(GetFoodRequestModel.fromJson(data));
      },
    );
  }


  // Future<Either<Failure, GetFoodRequestEntity>> getRestaurantOrders(
  //     PaginationOrderFoodParams params) async {
  //   final response =
  //       await _apiServices.get(EndPoints.getRestaurantOrders(params));
  //   return response.fold((failure) => Left(failure),
  //       (data) => Right(GetFoodRequestModel.fromJson(data)));
  // }

  @override
  Future<Either<Failure, GetAllRestaurantEntity>> getRestaurantInfo() async {
    final response = await _apiServices.get(EndPoints.getRestaurantInfo);

    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(GetAllRestaurantModel.fromJson(data['data']));
    });
  }

  @override
  Future<Either<Failure, RestaurantStatistics>>
      getRestaurantStatistics() async {
    final response = await _apiServices.get(EndPoints.getRestaurantStatistics);
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(RestaurantStatistics.fromJson(data));
    });
  }

  @override
  Future<Either<Failure, bool>> deleteRestaurant(
      DeleteResturantParams params) async {
    final response = await _apiServices.delete(
        EndPoints.deleteRestaurant(params.restaurantId),
        queryParameters: {"subCategory": params.subCategoryId});
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, bool>> updateRestaurant(params) async {
    final response = await _apiServices.put(EndPoints.updateRestaurant,
        data: params.toJson(),);
        // queryParameters: {"subCategory": params.subcategoryId});
    return response.fold((l) {
      return Left(l);
    }, (data) {
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, CompleteOrderEntity>> completeOrder({required CompleteOrderParams params}) async{
    final response = await _apiServices.put("${EndPoints.completeOrder}${params.orderId}");
    return response.fold((l) {
      return Left(l);
    }, (data) {
      final blockHealthModel = CompleteOrderModel.fromJson(data);
      return Right(blockHealthModel);
    });
  }
}
