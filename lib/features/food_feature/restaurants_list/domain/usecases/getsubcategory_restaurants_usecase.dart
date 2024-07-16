import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_entity.dart';
import '../../../../../core/abstract/use_case.dart';

import '../repositories/resturant_list_repo.dart';

class GetSubCategoryRestaurantsUseCases
    extends UseCase<List<RestaurantEntity>, String> {
  final RestaurantListRepo _repo;
  GetSubCategoryRestaurantsUseCases(this._repo);

  @override
  Future<Either<Failure, List<RestaurantEntity>>> call(String params) {
    return _repo.getSubCategoryRestaurants(id: params);
  }
}
