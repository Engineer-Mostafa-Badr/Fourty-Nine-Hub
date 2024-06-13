import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/trip_model.dart';
import 'package:fourtyninehub/features/ride/trip_details/data/models/cancel_reason_model.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';

import '../../../../../core/data/datasources/json_parser.dart';

abstract class TripDetailsRemoteDataSource {
  Future<Either<Failure, TripModel>> getTripDetails({required int tripId});
  Future<Either<Failure, List<CancelReasonModel>>> getCancelReasons();
}

class TripDetailsRemoteDataSourceImpl implements TripDetailsRemoteDataSource {
  final JsonParser _apiConsumer;
  TripDetailsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, TripModel>> getTripDetails(
      {required int tripId}) async {
    final response = await _apiConsumer.get(Jsons.tripDetails);
    return response.fold((failure) => Left(failure),
        (r) => Right(TripModel.fromJson(r['data'])));
  }

  @override
  Future<Either<Failure, List<CancelReasonModel>>> getCancelReasons() async {
    final response = await _apiConsumer.get(Jsons.cancelReasons);
    return response.fold(
        (failure) => Left(failure),
        (r) => Right((r['data']['cancel_reasons'] as List)
            .map((e) => CancelReasonModel.fromJson(e))
            .toList()));
  }
}
