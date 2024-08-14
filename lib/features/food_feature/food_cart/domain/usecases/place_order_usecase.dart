import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/food_cart_repo.dart';

class PlaceOrderUseCase extends UseCase<bool, String> {
  final FoodCartRepo _repo;
  PlaceOrderUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await _repo.placeOrder(cartId: params);
  }
}
