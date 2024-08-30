import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import '../../../../../../core/abstract/use_case.dart';

import '../repositories/restaurant_details_repo.dart';

class GetRestaurantDetailsUseCase extends UseCase<Restaurant, String> {
  final RestaurantDetailsRepo _repo;
  GetRestaurantDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, Restaurant>> call(String params) {
    return _repo.getRestaurantDetails(restaurantId: params);
  }
}
