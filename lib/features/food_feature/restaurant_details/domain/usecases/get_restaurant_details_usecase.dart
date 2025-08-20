import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../../../../core/abstract/use_case.dart';

import '../repositories/restaurant_details_repo.dart';

class GetRestaurantDetailsUseCase extends UseCase<GetAllRestaurantEntity, String> {
  final RestaurantDetailsRepo _repo;
  GetRestaurantDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, GetAllRestaurantEntity>> call(String params) {
    return _repo.getRestaurantDetails(restaurantId: params);
  }
}
