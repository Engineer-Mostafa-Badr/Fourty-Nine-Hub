import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';

import '../../domain/repositories/food_cart_repo.dart';
import '../datasources/food_cart_remote_datasource.dart';

class FoodCartRepoImpl implements FoodCartRepo {
  final FoodCartRemoteDataSource _remoteDataSource;
  FoodCartRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, CartEntity>> getCart() {
    return _remoteDataSource.getCart();
  }

  @override
  Future<Either<Failure, bool>> placeOrder({required String cartId}) {
    return _remoteDataSource.placeOrder(cartId: cartId);
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(
      {required RemoveFromCartParams params}) {
    return _remoteDataSource.removeFromCart(params: params);
  }
}
