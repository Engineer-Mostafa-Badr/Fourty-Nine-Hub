import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/privacy/data/models/privacy_model.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/privacy_entity.dart';

abstract class PrivacyDataSource {
  Future<Either<Failure, PrivacyEntity>> fetchDataPrivacy();
}

class PrivacyDataSourceImpl extends PrivacyDataSource {
  final ApiConsumer _apiConsumer;

  PrivacyDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, PrivacyEntity>> fetchDataPrivacy() async {
    var response = await _apiConsumer.get(EndPoints.privacy);

    return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(PrivacyModel.fromJson(response['data'])),
    );
  }
}
