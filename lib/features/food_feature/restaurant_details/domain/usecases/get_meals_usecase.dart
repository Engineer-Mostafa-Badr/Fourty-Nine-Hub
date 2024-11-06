import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';
import '../../../../../../core/abstract/use_case.dart';

import '../repositories/restaurant_details_repo.dart';

class GetMealsUseCase extends UseCase<List<RestaurantMenu>, GetMealsParams> {
  final RestaurantDetailsRepo _repo;
  GetMealsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RestaurantMenu>>> call(GetMealsParams params) {
    return _repo.getMeals(params: params);
  }
}

class GetMealsParams{
  final String restaurantId;
  final int page;
  final int limit;

  GetMealsParams({required this.restaurantId, required this.page, required this.limit});
}
