import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/repositories/ad_requests_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRequestsLogByMainCategoryUseCase extends UseCase<
    List<RequestsLogByMainCategoryEntity>, GetRequestsLogByMainCategoryParams> {
  final AdRequestsRepo _repo;

  GetRequestsLogByMainCategoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>> call(
      GetRequestsLogByMainCategoryParams params) {
    return _repo.getRequestsLogByMainCategory(params: params);
  }
}

class GetRequestsLogByMainCategoryParams {
  final String mainCategoryId;
  final int page;
  final int limit;

  GetRequestsLogByMainCategoryParams({
    required this.mainCategoryId,
    required this.page,
    required this.limit,
  });

  // Map<String, dynamic> toJson() => {"page": page, "limit": limit};
}
