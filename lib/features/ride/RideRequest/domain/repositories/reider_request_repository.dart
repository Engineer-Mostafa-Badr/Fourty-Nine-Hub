import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/datasources/rider_data_source.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/get_trip_info_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/rider_register_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/trip_request_model.dart';

class ReiderRequestRepository {
  final RiderDataSource dataSource;

  ReiderRequestRepository({required this.dataSource});

  Future<Either<Failure, Map<String, dynamic>>> getCateogry() {
    return dataSource.getCateogryData();
  }

  Future<Either<Failure, Map<String, dynamic>>> registerDriver(
      {required RiderRegisterModel model}) {
    return dataSource.registerDriver(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> riderRegister(
      {required RiderRegisterModel model}) {
    return dataSource.riderRegister(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> getTripInfo(
      {required GetTripInfoRequestModel model}) {
    return dataSource.getTripInfo(model: model);
  }

  Future<Either<Failure, Map<String, dynamic>>> pictureOptional() {
    return dataSource.pictureOptional();
  }

  Future<Either<Failure, Map<String, dynamic>>> request({required TripRequestModel model}) {
    return dataSource.requestTrip(model: model);
  }
}
