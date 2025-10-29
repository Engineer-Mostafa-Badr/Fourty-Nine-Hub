import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/data/models/requests_log_by_main_category_model.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_requests_log_by_main_category_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class AdRequestsRemoteDataSource {
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>> getAdRequests(
      {required GetAdRequestsParams params});
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>>
      getRequestsLogByMainCategory(
          {required GetRequestsLogByMainCategoryParams params});
}

class AdRequestsRemoteDataSourceImpl extends AdRequestsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AdRequestsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>> getAdRequests(
      {required GetAdRequestsParams params}) async {
    final response = await _apiConsumer.get(
      EndPoints.getAdRequests(params),
    );

    try {
      return response.fold((failure) => Left(failure), (data) {
        // return Right((data['data'] as List)
        //     .map((e) => AdRequestModel.fromJson(e))
        //     .toList());
        return Right((data['data'] as List)
            .map((e) => RequestsLogByMainCategoryModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      print(e);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>>
      getRequestsLogByMainCategory(
          {required GetRequestsLogByMainCategoryParams params}) async {
    final response = await _apiConsumer.get(
      EndPoints.getRequestsLogByMainCategory(params),
    );

    try {
      return response.fold((failure) => Left(failure), (data) {
        return Right((data['data']['requests'] as List)
            .map((e) => RequestsLogByMainCategoryModel.fromJson(e))
            .toList());
      });
    } catch (e) {
      print(e);
      return Left(UnknownFailure(e.toString()));
    }
  }
}
