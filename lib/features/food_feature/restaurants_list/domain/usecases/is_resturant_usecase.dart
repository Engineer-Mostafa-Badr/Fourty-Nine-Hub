import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

class IsResturantUsecase extends UseCase<bool, NoParams> {
  final RestaurantListRepo _repo;

  IsResturantUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repo.isRestaurant();
  }
}
