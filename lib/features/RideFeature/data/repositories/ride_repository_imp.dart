import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/datasources/ride_remote_data_source.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class RideRepositoryImplementation extends RideRepository {

  final RideRemoteDataSource rideRemoteDataSource;

  RideRepositoryImplementation(this.rideRemoteDataSource);

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId) async {
    return await rideRemoteDataSource.getRideCategories(userId);
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId) async {
    return await rideRemoteDataSource.getShippingCategories(userId);
  }
}