import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/datasources/request_history_remote_data_source.dart';
import 'package:fourtyninehub/features/requests_history/data/models/food_order_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';

import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';

import '../../domain/repositories/history_ride_repo.dart';

class RequestHistoryRepoImpl extends RequestHistoryRepo {
  final RequestHistoryRemoteDataSource _remoteDataSource;
  RequestHistoryRepoImpl(this._remoteDataSource);

  // @override
  // Future<Either<Failure, List<TripModel>>> getRideHistory() async {
  //   return await _remoteDataSource.getRideHistory();
  // }

  @override
  Future<Either<Failure, List<FoodOrderModel>>> getFoodHistory() async {
    return await _remoteDataSource.getFoodHistory();
  }

  @override
  Future<Either<Failure, List<ShippingRequestModel>>>
      getShippingRequests() async {
    return await _remoteDataSource.getShippingRequests();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> rating({
    required int trip,
    required int driver,
    required int service,
    required String comment,
    required String driverId,
    required String loadingTripId,
    required String categoryId,
  }) {
    return _remoteDataSource.rating(
      trip: trip,
      driver: driver,
      service: service,
      comment: comment,
      driverId: driverId,
      loadingTripId: loadingTripId,
      categoryId: categoryId,
    );
  }
}
