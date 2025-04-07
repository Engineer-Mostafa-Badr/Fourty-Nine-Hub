import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_categories_usecase.dart';

import '../../../../core/error/failure.dart';
import '../entities/ride_category_entity.dart';
import '../repositories/ride_repository.dart';

class GetShippingCategoriesUsecase {
  final RideRepository repository;

  GetShippingCategoriesUsecase(this.repository);

  Future<Either<Failure, RideCategoryEntityUpdated>> call(GetRideCategoriesParams params) {
    return repository.getShippingCategories(params);
  }
}
