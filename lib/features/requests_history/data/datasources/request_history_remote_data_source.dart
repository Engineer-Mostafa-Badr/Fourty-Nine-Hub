import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/requests_history/data/models/food_order_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';

import '../../../../core/error/failure.dart';
import '../../../../res/assets/jsons.dart';

abstract class RequestHistoryRemoteDataSource {
  Future<Either<Failure, List<TripModel>>> getRideHistory();
  Future<Either<Failure, List<FoodOrderModel>>> getFoodHistory();
}

class RequestHistoryRemoteDataSourceImpl
    extends RequestHistoryRemoteDataSource {
  final JsonParser _apiConsumer;
  RequestHistoryRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<TripModel>>> getRideHistory() async {
    final response = await _apiConsumer.get(Jsons.trips);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['trips'] as List)
            .map((e) => TripModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<FoodOrderModel>>> getFoodHistory() async {
    final response = await _apiConsumer.get(Jsons.foodOrders);
    return response.fold((failure) => Left(failure), (data) => Right(
      (data['data']['orders'] as List).map((e) => FoodOrderModel.fromJson(e)).toList()
    ));
  }
}
