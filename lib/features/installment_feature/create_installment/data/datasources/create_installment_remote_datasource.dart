import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/data/models/installment_plan_model.dart';

import '../../../../../core/api/end_points.dart';
import '../../../../../core/error/failure.dart';

abstract class CreateInstallmentRemoteDataSource {
  Future<Either<Failure, bool>> createInstallmentPlan(
      {required InstallmentPlanModel plan});
}

class CreateInstallmentRemoteDataSourceImpl
    implements CreateInstallmentRemoteDataSource {
  final ApiConsumer _apiConsumer;
  CreateInstallmentRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> createInstallmentPlan(
      {required InstallmentPlanModel plan}) async {
    final response = await _apiConsumer.post(
        EndPoints.createInstallment(plan.adId ?? ''),
        data: plan.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }
}
