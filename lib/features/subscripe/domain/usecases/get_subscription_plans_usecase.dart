import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../entities/subscription_plans_entity.dart';
import '../repositories/subscription_plans_repo.dart';

class GetSubscriptionPlansUseCase
    extends UseCase<SubscriptionPlansEntity, String> {
  final SubscriptionPlansRepo _repo;
  GetSubscriptionPlansUseCase(this._repo);
  @override
  Future<Either<Failure, SubscriptionPlansEntity>> call(String params) {
    return _repo.getSubscriptionPlans(subCategoryId: params);
  }
}
