import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';

abstract class RideRemoteDataSource {
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);

  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);
}

class RideRemoteDataSourceImplementation
    implements RideRemoteDataSource {
  final ApiConsumer _apiConsumer;

  RideRemoteDataSourceImplementation(this._apiConsumer);


  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getRideCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated.fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getShippingCategories(userId),
      );

      return response.fold((failure) => Left(failure), (data) {
        RideCategoryModelUpdated rideCategoryModel = RideCategoryModelUpdated.fromJson(data['data']);
        return Right(rideCategoryModel);
      });
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

}