import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/subscription_amount_entity.dart';
import '../repositories/subscription_plans_repo.dart';

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
