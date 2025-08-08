import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

import '../repositories/restaurant_details_repo.dart';

class AddToCartUseCase {
  final RestaurantDetailsRepo _repo;
  AddToCartUseCase(this._repo);

  Future<Either<Failure, bool>> call({
    required String restaurantId,
    required String foodId,
    required int quantity,
  }) {
    return _repo.addToCart(
        restaurantId: restaurantId, foodId: foodId, quantity: quantity);
  }
}
