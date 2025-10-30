import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/is_restaurant_model.dart';
import '../repositories/restaurant_list_repo.dart';

class IsRestaurantUsecase extends UseCase<IsRestaurantModel, NoParams> {
  final RestaurantListRepo _repo;

  IsRestaurantUsecase(this._repo);

  @override
  Future<Either<Failure, IsRestaurantModel>> call(NoParams params) async {
    return await _repo.isRestaurant();
  }
}
