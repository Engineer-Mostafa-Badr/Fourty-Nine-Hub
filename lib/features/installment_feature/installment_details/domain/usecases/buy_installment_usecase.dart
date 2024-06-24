import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/features/installment_feature/installment_list/domain/entities/installment_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/installment_details_repo.dart';


class BuyWithInstallmentUseCase
    extends UseCase<bool, num> {
  final InstallmentDetailsRepo _repo;
  BuyWithInstallmentUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(num params) {
    return _repo.buyWithInstallment(duration: params);
  }
}
