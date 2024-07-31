import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/subscribe/domain/entities/subscribtion_plans_entity.dart';

import 'package:fourtyninehub/features/subscribe/domain/usecases/subscribe_usecase.dart';

import '../../domain/repositories/subscribtion_plans_repo.dart';
import '../datasources/subscribe_remote_datasource.dart';

class SubscribtionPlansRepoImpl implements SubscribtionPlansRepo {
  final SubscribeRemoteDataSource _remoteDataSource;
  SubscribtionPlansRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, SubscribtionPlansEntity>> getSubscribtionPlans(
      {required String subCategoryId}) {
    return _remoteDataSource.getSubscribtionPlans(subCategoryId: subCategoryId);
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
}
