import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/cart_entity.dart';
import '../usecases/remove_from_cart_usecase.dart';

abstract class FoodCartRepo {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, bool>> removeFromCart(
      {required RemoveFromCartParams params});
  Future<Either<Failure, bool>> placeOrder({
    required String cartId,
  });
}
