import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/restaurant_details_repo.dart';

class DeleteCartUseCase extends UseCase<bool, NoParams> {
  final RestaurantDetailsRepo _repository;

  const DeleteCartUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repository.deleteCart();
  }
}
