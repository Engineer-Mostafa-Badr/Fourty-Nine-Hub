import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/resturant_list_repo.dart';

class GetNumOfResturantUseCase {
  final RestaurantListRepo _repo;

  GetNumOfResturantUseCase(this._repo);

  Future<Either<Failure, int>> call() {
    return _repo.numOfRestaurants();
  }
}
