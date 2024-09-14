import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import '../../../../core/error/failure.dart';

abstract class SettingRemoteDataSource {
  Future<Either<Failure, bool>> deleteAccount();
}

class SettingRemoteDataSourceImpl extends SettingRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SettingRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> deleteAccount() async {
    var response = await _apiConsumer.delete(EndPoints.deleteAccount);

    return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(response['status']),
    );
  }
}
