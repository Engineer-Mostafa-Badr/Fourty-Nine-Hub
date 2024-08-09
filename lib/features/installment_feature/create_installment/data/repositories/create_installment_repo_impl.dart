import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/installment_feature/installment_list/data/models/installment_plan_model.dart';

import '../../domain/repositories/create_installment_repo.dart';
import '../datasources/create_installment_remote_datasource.dart';

class CreateInstallmentRepoImpl implements CreateInstallmentRepo {
  final CreateInstallmentRemoteDataSource _remoteDataSource;
  CreateInstallmentRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> createInstallmentPlan(
      {required InstallmentPlanModel plan}) {
    return _remoteDataSource.createInstallmentPlan(plan: plan);
  }
}
