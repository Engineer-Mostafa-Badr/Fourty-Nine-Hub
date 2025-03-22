import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/domain/entities/installment_entity.dart';

import '../../domain/repositories/installment_list_repo.dart';
import '../datasources/installment_list_remote_datasource.dart';

class InstallmentListRepoImpl implements InstallmentListRepo {
  final InstallmentListRemoteDataSource _remoteDataSource;
  InstallmentListRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<InstallmentEntity>>> getInstallmentsList() async {
    return await _remoteDataSource.getInstallmentsList();
  }
}
