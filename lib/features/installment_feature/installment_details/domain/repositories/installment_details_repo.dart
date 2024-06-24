import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../installment_list/domain/entities/installment_entity.dart';

abstract class InstallmentDetailsRepo {
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required int id});
  Future<Either<Failure, bool>> buyWithInstallment({required num duration});
}
