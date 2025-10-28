import 'package:dartz/dartz.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_list_repo.dart';

import '../entities/restaurant.dart';

class GetFoodAdsUseCase {
  final RestaurantListRepo _repo;
  GetFoodAdsUseCase(this._repo);

  Future<Either<Failure, List<GetAllRestaurantEntity>>> call(
      {required PaginationParams params}) {
    return _repo.getFoodAds(params);
  }
}
