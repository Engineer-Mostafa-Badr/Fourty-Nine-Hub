import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

class GetNumOfResturantUseCase {
  final RestaurantListRepo _repo;

  GetNumOfResturantUseCase(this._repo);

  Future<Either<Failure, int>> call() {
    return _repo.numOfRestaurants();
  }
}
