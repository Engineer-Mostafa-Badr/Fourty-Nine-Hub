import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../data/models/restaurant_model.dart';
import '../repositories/resturant_list_repo.dart';
import 'get_nearby_restaurants_usecase.dart';

class GetTrendingRestaurantsUseCase
    extends UseCase<List<RestaurantModel>, LocationParams> {
  final RestaurantListRepo _repo;
  GetTrendingRestaurantsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RestaurantModel>>> call(LocationParams params) {
    return _repo.getTrendingRestaurants(lat: params.lat, lng: params.lng);
  }
}
