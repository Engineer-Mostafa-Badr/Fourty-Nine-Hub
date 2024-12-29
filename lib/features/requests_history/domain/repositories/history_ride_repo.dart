import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';

import '../../data/models/food_order_model.dart';

abstract class RequestHistoryRepo {
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
