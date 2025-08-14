import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

import '../entity/complete_order_entity.dart';
import '../repositories/restaurant_dashboard_repo.dart';

class CompleteOrderUseCase extends UseCase<CompleteOrderEntity, CompleteOrderParams> {
  final RestaurantDashboardRepo _repository;

  const CompleteOrderUseCase(this._repository);

  @override
  Future<Either<Failure, CompleteOrderEntity>> call(CompleteOrderParams params) {
    return _repository.completeOrder(params:params);
  }
}

class CompleteOrderParams {
  final String orderId;

  CompleteOrderParams(
      {required this.orderId, });
}
