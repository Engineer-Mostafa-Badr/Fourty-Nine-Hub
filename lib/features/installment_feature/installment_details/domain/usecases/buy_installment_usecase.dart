import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/features/installment_feature/installment_list/domain/entities/installment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/installment_request_model.dart';
import '../repositories/installment_details_repo.dart';

class BuyWithInstallmentUseCase extends UseCase<bool, InstallmentRequestModel> {
  final InstallmentDetailsRepo _repo;
  BuyWithInstallmentUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(InstallmentRequestModel params) {
    return _repo.buyWithInstallment(params: params);
  }
}
