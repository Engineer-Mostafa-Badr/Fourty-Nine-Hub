import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/installment_feature/create_installment/domain/repositories/create_installment_repo.dart';
import '../../../installment_list/data/models/installment_plan_model.dart';

class CreateInstallmentUseCase extends UseCase<bool, InstallmentPlanModel> {
  final CreateInstallmentRepo _repo;

  CreateInstallmentUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(
    InstallmentPlanModel params,
  ) {
    return _repo.createInstallmentPlan(plan: params);
  }
}