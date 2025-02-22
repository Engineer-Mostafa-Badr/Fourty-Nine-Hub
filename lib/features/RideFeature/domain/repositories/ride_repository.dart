
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_category_entity.dart';

import '../../../../core/error/failure.dart';

abstract class RideRepository {
  Future<Either<Failure, RideCategoryEntityUpdated>> getRideCategories(String userId);
  Future<Either<Failure, RideCategoryEntityUpdated>> getShippingCategories(String userId);
}