import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/resturant_list_repo.dart';

class ToggleRestaurantFavouriteUseCase extends UseCase<bool, String> {
  final RestaurantListRepo _repo;
  ToggleRestaurantFavouriteUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.toggleRestaurantFavourite(params: params);
  }
}
