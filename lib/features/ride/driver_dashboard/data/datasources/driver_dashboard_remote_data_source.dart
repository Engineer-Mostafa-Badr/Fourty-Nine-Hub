import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/data/models/driver_statistics_model.dart';

import '../../../../../core/data/datasources/json_parser.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../res/assets/jsons.dart';
import '../../../../requests_history/data/models/trip_model.dart';

abstract class DriverDashboardRemoteDataSource {
  Future<Either<Failure, List<TripModel>>> getNewTrips();
  Future<Either<Failure, DriverStatisticsModel>> getStatistics();
}

class DriverDashboardRemoteDataSourceImpl
    implements DriverDashboardRemoteDataSource {
  final JsonParser _apiConsumer;
  DriverDashboardRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<TripModel>>> getNewTrips() async {
    final response = await _apiConsumer.get(Jsons.driverNewTrips);
    return response.fold(
        (l) => Left(l),
        (r) => Right(((r['data']['trips'] as List)
            .map((e) => TripModel.fromJson(e))
            .toList())));
  }

  @override
  Future<Either<Failure, DriverStatisticsModel>> getStatistics() async {
    final response = await _apiConsumer.get(Jsons.driverStatistics);
    return response.fold((l) => Left(l),
        (r) => Right(DriverStatisticsModel.fromJson(r['data'])));
  }
}
