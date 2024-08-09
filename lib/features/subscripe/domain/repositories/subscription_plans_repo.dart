import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';

import '../../../../core/error/failure.dart';
import '../entities/subscription_plans_entity.dart';
import '../usecases/subscribe_usecase.dart';

abstract class SubscriptionPlansRepo {
  Future<Either<Failure, SubscriptionPlansEntity>> getSubscriptionPlans(
      {required String subCategoryId});
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId});
  Future<Either<Failure, bool>> subscribe({required SubscribeParams data});
  Future<Either<Failure, List<SubscriptionAmountEntity>>>
      getActiveSubscriptionAmounts();
}
