import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_list_repo.dart';

import '../entities/rate_response_entity.dart';

class AddRateRestaurantUseCase extends UseCase<RateResponseEntity , AddRateRestaurantParams> {
  final RestaurantListRepo _repo;
  AddRateRestaurantUseCase(this._repo);

  @override
  Future<Either<Failure, RateResponseEntity >> call(AddRateRestaurantParams params) {
    return _repo.addRateRestaurant(params: params);
  }
}
class AddRateRestaurantParams {
  final String restaurantId;
  final num rate;
  final String comment;

  AddRateRestaurantParams({
    required this.restaurantId,
    required this.rate,
    required this.comment,
  });
  Map<String, dynamic> toJson() => {
    'rate': rate,
    'comment': comment,

  };

}
