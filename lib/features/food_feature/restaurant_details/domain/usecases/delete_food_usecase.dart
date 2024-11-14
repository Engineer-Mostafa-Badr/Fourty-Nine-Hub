import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';


class DeleteFoodUseCase
    extends UseCase<bool, String> {
  final RestaurantDetailsRepo _repository;

  const DeleteFoodUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repository.deleteFood(id:params);
  }
}
