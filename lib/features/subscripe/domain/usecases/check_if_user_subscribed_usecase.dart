import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../repositories/subscription_plans_repo.dart';

class CheckIfUserSubscribedUseCase extends UseCase<bool, String> {
  final SubscriptionPlansRepo _repo;
  CheckIfUserSubscribedUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.isUserSubscribed(subCategoryId: params);
  }
}
