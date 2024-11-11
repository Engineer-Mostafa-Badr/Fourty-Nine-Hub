import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/domain/repositories/restaurant_details_repo.dart';


class DeleteCartUseCase
    extends UseCase<bool, NoParams> {
  final RestaurantDetailsRepo _repository;

  const DeleteCartUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.deleteCart();
  }
}
