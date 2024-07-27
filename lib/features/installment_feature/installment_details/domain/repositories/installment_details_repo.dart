import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../installment_list/domain/entities/installment_entity.dart';
import '../../data/models/installment_request_model.dart';

abstract class InstallmentDetailsRepo {
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required String id});
  Future<Either<Failure, bool>> buyWithInstallment({required InstallmentRequestModel params});
}
