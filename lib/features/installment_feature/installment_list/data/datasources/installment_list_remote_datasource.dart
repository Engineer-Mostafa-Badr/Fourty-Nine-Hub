import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/installment_feature/installment_list/data/models/installment_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../domain/entities/installment_entity.dart';

abstract class InstallmentListRemoteDataSource {
  Future<Either<Failure, List<InstallmentEntity>>> getInstallmentsList();
}

class InstallmentListRemoteDataSourceImpl
    implements InstallmentListRemoteDataSource {
  final JsonParser _apiConsumer;
  InstallmentListRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<InstallmentEntity>>> getInstallmentsList() async {
    final response = await _apiConsumer.get(Jsons.installmentsList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['installment_list'] as List)
            .map((e) => InstallmentModel.fromJson(e))
            .toList()));
  }
}
