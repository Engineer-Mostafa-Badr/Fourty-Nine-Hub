import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/history_ride/data/datasources/remote_data_source.dart';

import 'package:fourtyninehub/features/ride/history_ride/data/models/trip_model.dart';

import '../../domain/repositories/history_ride_repo.dart';

class HistoryRideRepoImpl extends HistoryRideRepo {
  final HistoryRideRemoteDataSource _remoteDataSource;
  HistoryRideRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<TripModel>>> getTrips() async {
    return await _remoteDataSource.getTrips();
  }
}
