import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/installment_feature/installment_list/domain/entities/installment_entity.dart';

import '../../domain/repositories/installment_details_repo.dart';
import '../datasources/installment_details_remote_datasource.dart';

class InstallmentDetailsRepoImpl implements InstallmentDetailsRepo {
  final InstallmentDetailsRemoteDataSource _remoteDataSource;
  InstallmentDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, bool>> buyWithInstallment(
      {required num duration}) async {
    return await _remoteDataSource.buyWithInstallment(duration: duration);
  }

  @override
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required int id}) async {
    return await _remoteDataSource.getInstallmentDetails(id: id);
  }
}
