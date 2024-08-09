import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';
import 'package:fourtyninehub/features/subscripe/domain/repositories/subscription_plans_repo.dart';

class GetActiveSubscriptionAmountsUseCase
    extends UseCase<List<SubscriptionAmountEntity>, NoParams> {
  final SubscriptionPlansRepo _repo;

  GetActiveSubscriptionAmountsUseCase(this._repo);

  @override
  Future<Either<Failure, List<SubscriptionAmountEntity>>> call(
      NoParams params) {
    return _repo.getActiveSubscriptionAmounts();
  }
}
