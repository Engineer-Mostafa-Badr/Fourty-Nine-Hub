import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/check_driver_type_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';
import 'package:fourtyninehub/features/new_trip_join/data/models/create_price_per_seat_model.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/usecases/create_price_per_seat_use_case.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';

abstract class CaptainShareRemoteDataSource {
  Future<Either<Failure, CreatePricePerSeatEntity>> createPricePerSeat(CreatePricePerSeatParams params);
  Future<Either<Failure, bool>> createRoute(CreatePricePerSeatParams params);
}

class CaptainShareRemoteDataSourceImplementation
    implements CaptainShareRemoteDataSource {
  final ApiConsumer _apiConsumer;

  CaptainShareRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, CreatePricePerSeatEntity>> createPricePerSeat(CreatePricePerSeatParams params) async {
    try {
      final result = await _apiConsumer.post(
        EndPoints.captainSharePrice,
        data: params.toJson(),
      );

      return result.fold(
            (failure) => Left(failure),
            (response) {
          return Right(CreatePricePerSeatModel.fromJson(response['data']));
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createRoute(CreatePricePerSeatParams params) async {
    try {
      final result = await _apiConsumer.post(
        EndPoints.captainShareCreateRoute,
        data: params.toJson(),
      );

      return result.fold(
            (failure) => Left(failure),
            (response) {
          return Right(response['status']??false);
        },
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}