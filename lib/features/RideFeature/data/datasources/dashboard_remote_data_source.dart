import 'package:dartz/dartz.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../models/dashboards/trips_response_model.dart';

abstract class TripRemoteDataSource {
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(
      String subCategoryId);
  Future<Either<Failure, TripsResponseModel>> getPastTrips();
}

class TripRemoteDataSourceImplementation implements TripRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TripRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, TripsResponseModel>> getAvailableTrips(
      String subCategoryId) async {
    try {
      final response = await _apiConsumer
          .get(EndPoints.getAvailableTrips(subCategoryId), headers: {
        "Authorization":
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjE4OTFlYTdjLTcxNzgtNGI2NC05YWQwLWQxOTczMDU2ZjQ3NyIsImlhdCI6MTc0MTY0MTQzMCwiZXhwIjo1NTc0MTY0MTQzMCwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.jzkOMmnr4wFrc08KrTsO32ljxSQwLAxVnWsRob0c14s',
        "x-api-key": "25c8d94c24f45386b47e8ed21251555611181858a23b8d6b371ff5dc5313cb91",
      });

      return response.fold((failure) => Left(failure), (data) {
        TripsResponseModel tripsResponseModel =
            TripsResponseModel.fromJson(data);
        return Right(tripsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TripsResponseModel>> getPastTrips() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getPastTrips(1),headers: {
        "Authorization":
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjE4OTFlYTdjLTcxNzgtNGI2NC05YWQwLWQxOTczMDU2ZjQ3NyIsImlhdCI6MTc0MTY0MTQzMCwiZXhwIjo1NTc0MTY0MTQzMCwic3ViIjoiNjZjMzQ5ZDdhNjg0YWI0NzNmMWMxZWQ3In0.jzkOMmnr4wFrc08KrTsO32ljxSQwLAxVnWsRob0c14s',
        // "x-api-key": "25c8d94c24f45386b47e8ed21251555611181858a23b8d6b371ff5dc5313cb91",
      }
      );

      return response.fold((failure) => Left(failure), (data) {
        TripsResponseModel tripsResponseModel =
            TripsResponseModel.fromJson(data);
        return Right(tripsResponseModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
