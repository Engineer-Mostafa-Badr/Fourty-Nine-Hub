import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

class ToggleRestaurantFavouriteUseCase extends UseCase<bool, String> {
  final RestaurantListRepo _repo;
  ToggleRestaurantFavouriteUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.toggleRestaurantFavourite(params: params);
  }
}
