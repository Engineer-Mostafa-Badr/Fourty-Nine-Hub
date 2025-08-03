import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/restaurant_dashboard_repo.dart';

class DeleteRestaurantUseCase extends UseCase<bool, DeleteResturantParams> {
  final RestaurantDashboardRepo _repository;

  const DeleteRestaurantUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(DeleteResturantParams params) {
    return _repository.deleteRestaurant(params);
  }
}

class DeleteResturantParams {
  final String restaurantId;
  final String subCategoryId;

  DeleteResturantParams(
      {required this.restaurantId, required this.subCategoryId});
}
