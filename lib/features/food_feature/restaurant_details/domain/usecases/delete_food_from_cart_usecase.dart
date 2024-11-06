import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';


class DeleteFoodFromCartUseCase
    extends UseCase<bool, DeleteFoodFromCartParams> {
  final RestaurantDetailsRepo _repository;

  const DeleteFoodFromCartUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(DeleteFoodFromCartParams params) {
    return _repository.deleteFoodFromCart(params:params);
  }
}

class DeleteFoodFromCartParams {
  final String restaurantId;
  final String foodId;

  DeleteFoodFromCartParams({required this.restaurantId, required this.foodId});

  Map<String, dynamic> toJson() => {
    'restaurantId': restaurantId,
    'foodId': foodId,
  };
}