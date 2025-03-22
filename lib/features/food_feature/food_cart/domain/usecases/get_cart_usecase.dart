import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/domain/entities/cart_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/food_cart_repo.dart';

class GetCartUseCase extends UseCase<CartEntity, NoParams> {
  final FoodCartRepo _repo;
  GetCartUseCase(this._repo);
  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) async {
    return await _repo.getCart();
  }
}
