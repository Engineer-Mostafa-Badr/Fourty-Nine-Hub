import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ride_category_entity.dart';
import '../repositories/ride_repository.dart';

class GetRideCategoriesUseCase {
  final RideRepository repository;

  GetRideCategoriesUseCase(this.repository);

  Future<Either<Failure, RideCategoryEntityUpdated>> call(GetRideCategoriesParams params) {
    return repository.getRideCategories(params);
  }
}

class GetRideCategoriesParams{
  final bool refresh;
  final String userId;

  GetRideCategoriesParams({required this.refresh, required this.userId});
}
