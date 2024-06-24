import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../../installment_list/data/models/installment_model.dart';
import '../../../installment_list/domain/entities/installment_entity.dart';

abstract class InstallmentDetailsRemoteDataSource {
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required int id});
  Future<Either<Failure, bool>> buyWithInstallment({required num duration});
}

class InstallmentDetailsRemoteDataSourceImpl
    implements InstallmentDetailsRemoteDataSource {
  final JsonParser _apiConsumer;
  InstallmentDetailsRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, bool>> buyWithInstallment(
      {required num duration}) async {
    return Right(true);
  }

  @override
  Future<Either<Failure, InstallmentEntity>> getInstallmentDetails(
      {required int id}) async {
    final response = await _apiConsumer.get(Jsons.installment_details);
    return response.fold((failure) => Left(failure), (data) => Right(
      InstallmentModel.fromJson(data['data'])
    ));
  }
}
