import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/ride/driver_dashboard/data/models/driver_statistics_model.dart';

import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/domain/usecases/create_rider_offer_usecase.dart';

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

  @override
  Future<Either<Failure, String>> acceptTrip({required String id}) {
    return _remoteDataSource.acceptTrip(id: id);
  }

  @override
  Future<Either<Failure, bool>> createOffer(
      {required CreateRiderOfferParams params}) {
    return _remoteDataSource.createOffer(params: params);
  }
}
