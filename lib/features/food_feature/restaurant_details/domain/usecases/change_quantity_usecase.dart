import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';


class ChangeQuantityUseCase
    extends UseCase<bool, ChangeQuantityParams> {
  final RestaurantDetailsRepo _repository;

  const ChangeQuantityUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(ChangeQuantityParams params) {
    return _repository.changeQuantity(params:params);
  }
}

class ChangeQuantityParams{
  final String restaurantId;
  final String foodId;
  final int quantity;
  const ChangeQuantityParams({
    required this.restaurantId,
    required this.foodId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'restaurantId': restaurantId,
    "restaurantItem":{
      'foodId': foodId,
      'quantity': quantity
    }
  };
}