import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../core/abstract/use_case.dart';
import '../entities/restaurant.dart';
import '../repositories/resturant_list_repo.dart';

class GetSubCategoryRestaurantsUseCases
    extends UseCase<List<GetAllRestaurantEntity>, GetSubCategoryRestaurants> {
  final RestaurantListRepo _repo;
  GetSubCategoryRestaurantsUseCases(this._repo);

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> call(
      GetSubCategoryRestaurants params) {
    return _repo.getSubCategoryRestaurants(params: params);
  }
}

class GetSubCategoryRestaurants {
  final String id;
  final String userId;
  final int page;
  final int limit;

  GetSubCategoryRestaurants(
      {required this.id,
      required this.userId,
      required this.page,
      required this.limit});
}
