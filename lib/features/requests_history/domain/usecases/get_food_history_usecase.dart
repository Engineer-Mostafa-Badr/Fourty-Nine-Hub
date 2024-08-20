import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/requests_history/data/models/food_order_model.dart';
import 'package:fourtyninehub/features/requests_history/domain/repositories/history_ride_repo.dart';

class GetFoodHistoryUseCase extends UseCase<List<FoodOrderModel>, NoParams> {
  final RequestHistoryRepo _repository;

  const GetFoodHistoryUseCase(this._repository);

  @override
  Future<Either<Failure, List<FoodOrderModel>>> call(NoParams params) {
    return _repository.getFoodHistory();
  }
}
