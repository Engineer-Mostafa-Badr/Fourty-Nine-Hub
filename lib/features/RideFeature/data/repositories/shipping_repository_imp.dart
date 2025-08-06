
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/create_no_track_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_non_track_trip_use_case.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/check_driver_type_entity.dart';
import '../../domain/entities/create_loading_trip_entity.dart';
import '../../domain/entities/ride_category_entity.dart';
import '../../domain/repositories/shipping_repository.dart';
import '../datasources/shipping_remote_data_source.dart';
import '../models/create_loading_trip_model.dart';

class ShippingRepositoryImplementation extends ShippingRepository {

  final ShippingRemoteDataSource shippingRemoteDataSource;

  ShippingRepositoryImplementation(this.shippingRemoteDataSource);

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId) async {
    return await shippingRemoteDataSource.getRideCategories(userId);
  }

  @override
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId) async {
    return await shippingRemoteDataSource.getShippingCategories(userId);
  }

  @override
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType() async {
    return await shippingRemoteDataSource.checkDriverType();
  }

  @override
  Future<Either<Failure, bool>> createLoadingTrip(CreateLoadingTripParams params) async {
    return await shippingRemoteDataSource.createLoadingTrip(params);

  }


}