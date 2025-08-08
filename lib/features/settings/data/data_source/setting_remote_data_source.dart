import 'package:dartz/dartz.dart';
import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../models/disable_model.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/disable_entity.dart';

abstract class SettingRemoteDataSource {
  Future<Either<Failure, bool>> deleteAccount();
  Future<Either<Failure, DisableEntity>> disableAccount();
  Future<Either<Failure, DisableEntity>> enableAccount();
}

class SettingRemoteDataSourceImpl extends SettingRemoteDataSource {
  final ApiConsumer _apiConsumer;

  SettingRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> deleteAccount() async {
    var response = await _apiConsumer.delete(EndPoints.deleteAccount);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, DisableEntity>> disableAccount() async {
    var response = await _apiConsumer.put(EndPoints.disableAccount);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(DisableModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, DisableEntity>> enableAccount() async {
    var response = await _apiConsumer.put(EndPoints.enableAccount);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(DisableModel.fromJson(response['data'])),
    );
  }
}
