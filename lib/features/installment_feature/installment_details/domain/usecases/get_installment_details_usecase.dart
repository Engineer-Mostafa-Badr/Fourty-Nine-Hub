import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/features/installment_feature/installment_list/domain/entities/installment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/installment_details_repo.dart';

class GetInstallmentDetailsUseCase extends UseCase<InstallmentEntity, String> {
  final InstallmentDetailsRepo _repo;
  GetInstallmentDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, InstallmentEntity>> call(String params) {
    return _repo.getInstallmentDetails(id: params);
  }
}
