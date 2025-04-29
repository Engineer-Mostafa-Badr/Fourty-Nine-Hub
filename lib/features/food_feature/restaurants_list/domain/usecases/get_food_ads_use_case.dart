import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';

import '../entities/food_ads_entity.dart';
import '../entities/logs_entity.dart';
import '../entities/restaurant.dart';

class GetFoodAdsUseCase {
  final RestaurantListRepo _repo;
  GetFoodAdsUseCase(this._repo);

  Future<Either<Failure, List<GetAllRestaurantEntity>>> call(
      {required PaginationParams params}) {
    return _repo.getFoodAds(params);
  }
}
