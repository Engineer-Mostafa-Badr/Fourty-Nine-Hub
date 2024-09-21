import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';

class RiderDataSource {
  final ApiConsumer api;

  RiderDataSource({required this.api});

  Future<Either<Failure, Map<String, dynamic>>> getCateogryData() {
    return api
        .get("${EndPoints.bannerDataRider}?userId=66c349d7a684ab473f1c1ed7");
  }

  Future<Either<Failure, Map<String, dynamic>>> registerDriver(
      {required RiderRegisterModel model}) {
    return api.post(EndPoints.specialRegister, data: model.registerOne());
  }

  Future<Either<Failure, Map<String, dynamic>>> riderRegister(
      {required RiderRegisterModel model}) {
    return api.post(EndPoints.riderRegister, data: model.registerTow());
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripInfo(
      {required GetTripInfoRequestModel model}) {
    return api.post("${EndPoints.expectedPrice}/${model.subCateogryId}",
        data: model.toJson());
  }

  Future<Either<Failure, Map<String, dynamic>>> pictureOptional() {
    return api.get(EndPoints.pictureOptional);
  }
  Future<Either<Failure, Map<String, dynamic>>> requestTrip({required TripRequestModel model}) {
    return api.post(EndPoints.newTripRide, data: model.toJson());
  }
}
