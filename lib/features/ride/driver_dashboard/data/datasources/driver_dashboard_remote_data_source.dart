import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/data/models/driver_statistics_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../../requests_history/data/models/trip_model.dart';
import '../../domain/usecases/create_rider_offer_usecase.dart';

abstract class DriverDashboardRemoteDataSource {
  Future<Either<Failure, List<TripModel>>> getNewTrips();
  Future<Either<Failure, DriverStatisticsModel>> getStatistics();
  Future<Either<Failure, bool>> createOffer(
      {required CreateRiderOfferParams params});

  Future<Either<Failure, String>> acceptTrip({required String id});
}

class DriverDashboardRemoteDataSourceImpl
    implements DriverDashboardRemoteDataSource {
  final ApiConsumer _apiConsumer;
  DriverDashboardRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<TripModel>>> getNewTrips() async {
    final response = await _apiConsumer.get(EndPoints.getRiderNewTrips);
    return response.fold(
        (l) => Left(l),
        (r) => Right(((r['data'] as List)
            .map((e) => TripModel.fromJson(e['ride'] as Map<String, dynamic>))
            .toList())));
  }

  @override
  Future<Either<Failure, DriverStatisticsModel>> getStatistics() async {
    final response = await _apiConsumer.get(Jsons.driverStatistics);
    return response.fold((l) => Left(l),
        (r) => Right(DriverStatisticsModel.fromJson(r['data'])));
  }

  @override
  Future<Either<Failure, String>> acceptTrip({required String id}) async {
    final response = await _apiConsumer.put(EndPoints.acceptTripRider(id));
    return response.fold((l) => Left(l), (data) => Right(id));
  }

  @override
  Future<Either<Failure, bool>> createOffer(
      {required CreateRiderOfferParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.createOffer(params.tripId), data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
