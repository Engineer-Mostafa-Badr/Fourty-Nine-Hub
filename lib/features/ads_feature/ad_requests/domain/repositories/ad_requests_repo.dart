import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_requests_log_by_main_category_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class AdRequestsRepo {
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>> getAdRequests(
      {required GetAdRequestsParams params});
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>>
      getRequestsLogByMainCategory(
          {required GetRequestsLogByMainCategoryParams params});
}
