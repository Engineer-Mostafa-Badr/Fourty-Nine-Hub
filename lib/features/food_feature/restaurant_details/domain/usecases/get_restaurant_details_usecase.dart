import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';

import '../../../restaurants_list/domain/entities/restaurant_entity.dart';
import '../repositories/restaurant_details_repo.dart';

class GetRestaurantDetailsUseCase extends UseCase<RestaurantEntity, String> {
  final RestaurantDetailsRepo _repo;
  GetRestaurantDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, RestaurantEntity>> call(String params) {
    return _repo.getRestaurantDetails(restaurantId: params);
  }
}
