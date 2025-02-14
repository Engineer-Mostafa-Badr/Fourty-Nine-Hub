import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/models/privacy_model.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/connection_privacy_entity.dart';
import '../../domain/entities/personal_privacy_entity.dart';
import '../../domain/entities/privacy_entity.dart';
import '../../domain/useCase/update_privacy_use_case.dart';
import '../models/connection_privacy_model.dart';
import '../models/personal_privacy_model.dart';

abstract class PrivacyDataSource {
  Future<Either<Failure, PersonalPrivacyEntity >> fetchDataPersonalPrivacy();
  Future<Either<Failure, ConnectionPrivacyEntity >> fetchDataConnectionPrivacy();

  Future<Either<Failure, PrivacyEntity>> updateDataPrivacy(
      UpdatePrivacyParams params);
}

class PrivacyDataSourceImpl extends PrivacyDataSource {
  final ApiConsumer _apiConsumer;

  PrivacyDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, PersonalPrivacyEntity>> fetchDataPersonalPrivacy() async {
    var response = await _apiConsumer.get(EndPoints.privacy);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(PersonalPrivacyModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, PrivacyEntity>> updateDataPrivacy(
      UpdatePrivacyParams params) async {
    var response = await _apiConsumer.put(
      EndPoints.privacy,
      data: params.toJson(),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(PrivacyModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, ConnectionPrivacyEntity>> fetchDataConnectionPrivacy() async{
    var response = await _apiConsumer.get(EndPoints.privacyConnection);

    return response.fold(
          (failure) => Left(failure),
          (response) => Right(ConnectionPrivacyModel.fromJson(response['data'])),
    );
  }
}
