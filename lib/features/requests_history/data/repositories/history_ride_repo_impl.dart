import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/datasources/request_history_remote_data_source.dart';
import 'package:fourtyninehub/features/requests_history/data/models/food_order_model.dart';

import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';

import '../../domain/repositories/history_ride_repo.dart';

class RequestHistoryRepoImpl extends RequestHistoryRepo {
  final RequestHistoryRemoteDataSource _remoteDataSource;
  RequestHistoryRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<TripModel>>> getRideHistory() async {
    return await _remoteDataSource.getRideHistory();
  }

  @override
  Future<Either<Failure, List<FoodOrderModel>>> getFoodHistory() async {
   
   return await _remoteDataSource.getFoodHistory();
   
  }
}
