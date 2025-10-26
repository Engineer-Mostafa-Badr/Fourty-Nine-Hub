import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_list_repo.dart';

class ChangeConnectivityUseCase {
  final RestaurantListRepo _repo;
  ChangeConnectivityUseCase(this._repo);

  Future<Either<Failure, bool>> call({required bool params}) {
    return _repo.changeConnectivity(params);
  }
}
