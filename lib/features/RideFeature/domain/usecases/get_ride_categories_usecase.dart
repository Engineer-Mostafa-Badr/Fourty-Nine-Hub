import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ride_category_entity.dart';
import '../repositories/ride_repository.dart';

class GetRideCategoriesUseCase {
  final RideRepository repository;

  GetRideCategoriesUseCase(this.repository);

  Future<Either<Failure, RideCategoryEntityUpdated>> call(String userId) {
    return repository.getRideCategories(userId);
  }
}
