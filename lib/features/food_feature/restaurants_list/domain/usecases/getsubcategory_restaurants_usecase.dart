import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import '../../../../../core/abstract/use_case.dart';

import '../repositories/resturant_list_repo.dart';

class GetSubCategoryRestaurantsUseCases
    extends UseCase<List<Restaurant2Model>, GetSubCategoryRestaurants> {
  final RestaurantListRepo _repo;
  GetSubCategoryRestaurantsUseCases(this._repo);

  @override
  Future<Either<Failure, List<Restaurant2Model>>> call(GetSubCategoryRestaurants params) {
    return _repo.getSubCategoryRestaurants(params: params);
  }
}

class GetSubCategoryRestaurants{
  final String id;
  final String userId;
  final int page;
  final int limit;

  GetSubCategoryRestaurants({required this.id,required this.userId, required this.page, required this.limit});
}