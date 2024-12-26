import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/repositories/ad_requests_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetAdRequestsUseCase
    extends UseCase<List<AdRequestEntity>, GetAdRequestsParams> {
  final AdRequestsRepo _repo;
  GetAdRequestsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdRequestEntity>>> call(
      GetAdRequestsParams params) {
    return _repo.getAdRequests(params: params);
  }
}

class GetAdRequestsParams {
  final String id;
  final int page;
  final int limit;
  final String username;

  GetAdRequestsParams(
      {required this.id,
      required this.page,
      required this.limit,
      required this.username});

  Map<String, dynamic> toJson() =>
      {"username": username, "page": page, "limit": limit};
}
