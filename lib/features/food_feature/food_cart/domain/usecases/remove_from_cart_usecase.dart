import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/food_cart_repo.dart';

class RemoveFromCartUseCase extends UseCase<bool, RemoveFromCartParams> {
  final FoodCartRepo _repo;
  RemoveFromCartUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(RemoveFromCartParams params) async {
    return await _repo.removeFromCart(params: params);
  }
}

class RemoveFromCartParams {
  final String restaurantId;
  final String foodId;
  RemoveFromCartParams({required this.restaurantId, required this.foodId});
  Map<String, dynamic> toJson() =>
      {"restuarantId": restaurantId, "foodId": foodId};
}
