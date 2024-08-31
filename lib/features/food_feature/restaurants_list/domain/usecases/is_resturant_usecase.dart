import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

class IsResturantUsecase extends UseCase<IsRestaurantModel, NoParams> {
  final RestaurantListRepo _repo;

  IsResturantUsecase(this._repo);

  @override
  Future<Either<Failure, IsRestaurantModel>> call(NoParams params) async {
    return await _repo.isRestaurant();
  }
}
