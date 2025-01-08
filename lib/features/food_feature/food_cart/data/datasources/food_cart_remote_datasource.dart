import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/entities/cart_entity.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../models/cart_model.dart';

abstract class FoodCartRemoteDataSource {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, bool>> removeFromCart(
      {required RemoveFromCartParams params});
  Future<Either<Failure, bool>> placeOrder({
    required String cartId,
  });
}

class FoodCartRemoteDataSourceImpl implements FoodCartRemoteDataSource {
  final ApiConsumer _apiConsumer;
  FoodCartRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    final response = await _apiConsumer.get(EndPoints.getCart);
    return response.fold(
        (l) => Left(l), (data) => Right(CartModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, bool>> removeFromCart(
      {required RemoveFromCartParams params}) async {
    final response = await _apiConsumer.delete(EndPoints.deleteFromCart,
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> placeOrder({required String cartId}) async {
    final response = await _apiConsumer.post(EndPoints.placeOrder,
        data: {"cartId": cartId}, queryParameters: {"subCategory": ""});
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
