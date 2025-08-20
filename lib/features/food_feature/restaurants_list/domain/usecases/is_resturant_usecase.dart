import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/is_restaurant_model.dart';
import '../repositories/resturant_list_repo.dart';

class IsResturantUsecase extends UseCase<IsRestaurantModel, NoParams> {
  final RestaurantListRepo _repo;

  IsResturantUsecase(this._repo);

  @override
  Future<Either<Failure, IsRestaurantModel>> call(NoParams params) async {
    return await _repo.isRestaurant();
  }
}
