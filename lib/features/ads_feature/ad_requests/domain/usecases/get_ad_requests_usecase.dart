import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/repositories/ad_requests_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetAdRequestsUseCase extends UseCase<
    List<RequestsLogByMainCategoryEntity>, GetAdRequestsParams> {
  final AdRequestsRepo _repo;

  GetAdRequestsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RequestsLogByMainCategoryEntity>>> call(
      GetAdRequestsParams params) {
    return _repo.getAdRequests(params: params);
  }
}

class GetAdRequestsParams {
  final String id;
  final int page;
  final int limit;
  final String username;

  GetAdRequestsParams({
    required this.id,
    required this.page,
    required this.limit,
    required this.username,
  });

  Map<String, dynamic> toJson() => {"page": page, "limit": limit};
}
