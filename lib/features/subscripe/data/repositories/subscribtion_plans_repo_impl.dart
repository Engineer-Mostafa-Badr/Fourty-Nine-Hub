import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_plans_entity.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/subscribe_usecase.dart';

import '../../domain/repositories/subscription_plans_repo.dart';
import '../datasources/subscribe_remote_datasource.dart';

class SubscriptionPlansRepoImpl implements SubscriptionPlansRepo {
  final SubscribeRemoteDataSource _remoteDataSource;
  SubscriptionPlansRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, SubscriptionPlansEntity>> getSubscriptionPlans(
      {required String subCategoryId}) {
    return _remoteDataSource.getSubscriptionPlans(subCategoryId: subCategoryId);
  }

  @override
  Future<Either<Failure, bool>> isUserSubscribed(
      {required String subCategoryId}) {
    return _remoteDataSource.isUserSubscribed(subCategoryId: subCategoryId);
  }

  @override
  Future<Either<Failure, bool>> subscribe({required SubscribeParams data}) {
    return _remoteDataSource.subscribe(data: data);
  }

  @override
  Future<Either<Failure, List<SubscriptionAmountEntity>>>
      getActiveSubscriptionAmounts() {
    return _remoteDataSource.getActiveSubscriptionAmounts();
  }
}
