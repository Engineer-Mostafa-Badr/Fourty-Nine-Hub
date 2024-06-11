import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/ride/driver_dashboard/data/models/driver_statistics_model.dart';

import 'package:fourtyninehub/features/ride/history_ride/data/models/trip_model.dart';

import '../../domain/repositories/driver_dashboard_repo.dart';
import '../datasources/driver_dashboard_remote_data_source.dart';

class DriverDashboardRepoImpl implements DriverDashboardRepo {
  final DriverDashboardRemoteDataSource _remoteDataSource;
  DriverDashboardRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<TripModel>>> getNewTrips() async {
    return await _remoteDataSource.getNewTrips();
  }

  @override
  Future<Either<Failure, DriverStatisticsModel>> getStatistics() async {
    return await _remoteDataSource.getStatistics();
  }
}
