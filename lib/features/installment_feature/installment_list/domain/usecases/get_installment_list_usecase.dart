import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/domain/entities/installment_entity.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/domain/repositories/installment_list_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetInstallmentListUseCase
    extends UseCase<List<InstallmentEntity>, String> {
  final InstallmentListRepo _repo;
  GetInstallmentListUseCase(this._repo);

  @override
  Future<Either<Failure, List<InstallmentEntity>>> call(String params) {
    return _repo.getInstallmentsList();
  }
}
