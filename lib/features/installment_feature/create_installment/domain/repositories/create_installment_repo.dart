import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../installment_list/data/models/installment_plan_model.dart';

abstract class CreateInstallmentRepo {
  Future<Either<Failure, bool>> createInstallmentPlan(
      {required InstallmentPlanModel plan});
}
