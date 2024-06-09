import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/ride/history_ride/data/models/trip_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';

abstract class HistoryRideRemoteDataSource {
  Future<Either<Failure, List<TripModel>>> getTrips();
}

class HistoryRideRemoteDataSourceImpl extends HistoryRideRemoteDataSource {
  final JsonParser _apiConsumer;
  HistoryRideRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<TripModel>>> getTrips() async {
    final response = await _apiConsumer.get(Jsons.trips);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['trips'] as List)
            .map((e) => TripModel.fromJson(e))
            .toList()));
  }
}
