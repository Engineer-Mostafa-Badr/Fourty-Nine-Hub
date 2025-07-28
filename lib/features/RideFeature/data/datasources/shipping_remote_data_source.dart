import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/check_driver_type_model.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';

abstract class ShippingRemoteDataSource {
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      String userId);

  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      String userId);

  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType();

  Future<Either<Failure, bool>> createLoadingTrip(
      CreateLoadingTripParams params);
}

class ShippingRemoteDataSourceImplementation
    implements ShippingRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ShippingRemoteDataSourceImplementation(this._apiConsumer);


  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(
      String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated
            .fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(
      String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getShippingCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated
            .fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType() async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.checkDriverType,
      );

      return response.fold((failure) => Left(failure), (data) {
        CheckDriverTypeModel checkDriverTypeModel = CheckDriverTypeModel
            .fromJson(data['data']);
        return Right(checkDriverTypeModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createLoadingTrip(
      CreateLoadingTripParams params) async {
    try {
      final result = await _apiConsumer.post(
        EndPoints.createLoadingTrip,
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