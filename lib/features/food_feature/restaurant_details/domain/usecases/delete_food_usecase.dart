import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_details_repo.dart';

class DeleteFoodUseCase extends UseCase<bool, String> {
  final RestaurantDetailsRepo _repository;

  const DeleteFoodUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.deleteFood(id: params);
  }
}
