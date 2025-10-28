import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_list_repo.dart';
import 'get_nearby_restaurants_usecase.dart';

class GetTrendingRestaurantsUseCase
    extends UseCase<List<GetAllRestaurantEntity>, LocationParams> {
  final RestaurantListRepo _repo;
  GetTrendingRestaurantsUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllRestaurantEntity>>> call(LocationParams params) {
    return _repo.getTrendingRestaurants(lat: params.lat, lng: params.lng);
  }
}
