import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/ride/history_ride/data/models/trip_model.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/datasources/remote_data_source.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/models/cancel_reason_model.dart';

import '../../domain/repositories/trip_details_repo.dart';

class TripDetailsRepoImpl implements TripDetailsRepo {
  final TripDetailsRemoteDataSource _remoteDataSource;
  TripDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, TripModel>> getTripDetails(
      {required int tripId}) async {
    return _remoteDataSource.getTripDetails(tripId: tripId);
  }

  @override
  Future<Either<Failure, List<CancelReasonModel>>> getCancelReasons() {
    return _remoteDataSource.getCancelReasons();
  }
}
