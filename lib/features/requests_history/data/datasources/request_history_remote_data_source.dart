import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/requests_history/data/models/food_order_model.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';

import '../../../../core/error/failure.dart';
import '../../../../res/assets/jsons.dart';

abstract class RequestHistoryRemoteDataSource {
  // Future<Either<Failure, List<TripModel>>> getRideHistory();
  Future<Either<Failure, List<ShippingRequestModel>>> getShippingRequests();
  Future<Either<Failure, List<FoodOrderModel>>> getFoodHistory();
  Future<Either<Failure, Map<String, dynamic>>> rating(
      {required int trip,
      required int driver,
      required int service,
      required String comment,
      required String driverId,
      required String loadingTripId,
      required String categoryId});
}

class RequestHistoryRemoteDataSourceImpl
    extends RequestHistoryRemoteDataSource {
  final ApiConsumer _apiConsumer;
  RequestHistoryRemoteDataSourceImpl(this._apiConsumer);

  // @override
  // Future<Either<Failure, List<TripModel>>> getRideHistory() async {
  //   print("hello == from ride \n");

  //   final response =
  //       await _apiConsumer.get("https://c433-41-239-172-48.ngrok-free.app/api/v1/ride/trips/use");
  //   print("response ==${response}\n");

  //   return response.fold(
  //       (failure) => Left(failure),
  //       (data) => Right((data['data']['trips'] as List)
  //           .map((e) => TripModel.fromJson(e))
  //           .toList()));
  // }

  @override
  Future<Either<Failure, List<FoodOrderModel>>> getFoodHistory() async {
    final response = await _apiConsumer.get(Jsons.foodOrders);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['orders'] as List)
            .map((e) => FoodOrderModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<ShippingRequestModel>>>
      getShippingRequests() async {
    print("hello == from shipping \n");
    final response = await _apiConsumer
        .get("https://c433-41-239-172-48.ngrok-free.app/api/v1/loading/trip/allUserTrips");
    print("response ==$response\n");
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => ShippingRequestModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> rating(
      {required int trip,
      required int driver,
      required int service,
      required String comment,
      required String driverId,
      required String loadingTripId,
      required String categoryId}) async {
    // var re = {
    //   "driverId": driverId,
    //   "categoryId": categoryId,
    //   "loadingTripId": loadingTripId,
    //   "rate": [trip, driver, service],
    //   "comment": comment
    // };
    // log(re.toString());
    // final response = await _apiConsumer.get(EndPoints.makeRatingDriver, data: {
    //   "driverId": "66d097916165474c5431e765",
    //   "categoryId": "62c8baad8e28a58a3edf5805",
    //   "loadingTripId": "66d09b436165474c5432edc7",
    //   "rate": [5, 3, 2],
    //   // [trip,driver,service]
    //   "comment": "That's Great"
    // });
    // log("$response", name: "lksjdflskjdflskdjflskdjf");
    return _apiConsumer.post(EndPoints.makeRatingDriver, data: {
      "driverId": driverId,
      "categoryId": categoryId,
      "loadingTripId": loadingTripId,
      "rate": [trip, driver, service],
      // [trip,driver,service]
      "comment": comment
    });
  }
}
