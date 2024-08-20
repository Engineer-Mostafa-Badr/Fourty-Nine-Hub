import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';

import '../../../../../core/api/end_points.dart';
import '../../../../../core/error/failure.dart';

import '../../../installment_list/data/models/installment_model.dart';
import '../../../installment_list/domain/entities/installment_entity.dart';
import '../models/installment_request_model.dart';

abstract class InstallmentDetailsRemoteDataSource {
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required String id});
  Future<Either<Failure, bool>> buyWithInstallment(
      {required InstallmentRequestModel params});
}

class InstallmentDetailsRemoteDataSourceImpl
    implements InstallmentDetailsRemoteDataSource {
  final ApiConsumer _apiConsumer;
  InstallmentDetailsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> buyWithInstallment(
      {required InstallmentRequestModel params}) async {
    final response = await _apiConsumer.post(
        EndPoints.addInstallmentRequest(params.installmentId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required String id}) async {
    final response = await _apiConsumer.get(EndPoints.installmentDetails(id));
    return response.fold((failure) => Left(failure),
        (data) => Right(InstallmentModel.fromJson(data['data'])));
  }
}
