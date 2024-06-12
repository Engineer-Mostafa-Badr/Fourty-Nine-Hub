import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../restaurants_list/data/models/restaurant_model.dart';
import '../repositories/restaurant_details_repo.dart';

class GetRestaurantDetailsUseCase extends UseCase<RestaurantModel, int> {
  final RestaurantDetailsRepo _repo;
  GetRestaurantDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, RestaurantModel>> call(int params) {
    return _repo.getRestaurantDetails(restaurantId: params);
  }
}
