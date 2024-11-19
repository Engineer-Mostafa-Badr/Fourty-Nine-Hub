import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/repositories/resturant_list_repo.dart';


class ChangeConnectivityUseCase {
  final RestaurantListRepo _repo;
  ChangeConnectivityUseCase(this._repo);

  Future<Either<Failure, bool>> call(
      {required bool params}) {
    return _repo.changeConnectivity(params);
  }
}
