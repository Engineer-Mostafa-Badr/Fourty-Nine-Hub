import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/data/models/ad_request_model.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';

import '../../../../../core/error/failure.dart';

abstract class AdRequestsRemoteDataSource {
  Future<Either<Failure, List<AdRequestEntity>>> getAdRequests(
      {required GetAdRequestsParams params});
}

class AdRequestsRemoteDataSourceImpl extends AdRequestsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AdRequestsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<AdRequestEntity>>> getAdRequests(
      {required GetAdRequestsParams params}) async {
    final response = await _apiConsumer.get(
      EndPoints.getAdRequests(params),
    );

    return response.fold((failure) => Left(failure), (data) {
      return Right((data['data'] as List)
          .map((e) => AdRequestModel.fromJson(e))
          .toList());
    });
  }
}
