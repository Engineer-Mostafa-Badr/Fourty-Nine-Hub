import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food/restaurants_list/data/repositories/restaurant_list_repo_impl.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../data/models/restaurant_model.dart';

class GetNearByRestaurantsUseCase
    extends UseCase<List<RestaurantModel>, LocationParams> {
  final RestaurantListRepoImpl _repo;
  GetNearByRestaurantsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RestaurantModel>>> call(LocationParams params) {
    return _repo.getNearByReasturants(lat: params.lat , lng: params.lng);
  }
}

class LocationParams {
  final double lat;
  final double lng;
  LocationParams({required this.lat,required this.lng});

}
