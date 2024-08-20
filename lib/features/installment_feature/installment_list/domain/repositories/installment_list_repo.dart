import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/installment_entity.dart';

abstract class InstallmentListRepo {
  Future<Either<Failure, List<InstallmentEntity>>> getInstallmentsList();
}
