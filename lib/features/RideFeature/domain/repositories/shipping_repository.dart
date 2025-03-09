import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/create_loading_trip_model.dart';
import '../entities/create_loading_trip_entity.dart';

abstract class ShippingRepository {
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);
  Future<Either<Failure, CheckDriverTypeEntity>> checkDriverType();
  Future<Either<Failure, CreateLoadingTripEntity>> createLoadingTrip(CreateLoadingTripModel params);
 }