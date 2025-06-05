import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_requests_log_by_main_category_use_case.dart';

import '../../domain/repositories/ad_requests_repo.dart';
import '../datasources/ad_requests_remote_data_source.dart';

class AdRequestsRepoImpl implements AdRequestsRepo {
  final AdRequestsRemoteDataSource _remoteDataSource;
  AdRequestsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>> getAdRequests(
      {required GetAdRequestsParams params}) async {
    return await _remoteDataSource.getAdRequests(params: params);
  }

  @override
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>>
      getRequestsLogByMainCategory(
          {required GetRequestsLogByMainCategoryParams params}) async {
    return await _remoteDataSource.getRequestsLogByMainCategory(params: params);
  }
}
