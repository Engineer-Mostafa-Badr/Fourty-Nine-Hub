import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/data/models/selected_meal_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/entities/meal_entity.dart';

import '../../../../../../core/abstract/use_case.dart';

import '../repositories/restaurant_details_repo.dart';

class AddToCartUseCase extends UseCase<bool, SelectedMealModel> {
  final RestaurantDetailsRepo _repo;
  AddToCartUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(SelectedMealModel params) {
    return _repo.addToCart(meal: params);
  }
}
