import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/ad_request_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/repositories/ad_requests_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetAdRequestsUseCase extends UseCase<List<AdRequestEntity>, String> {
  final AdRequestsRepo _repo;
  GetAdRequestsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdRequestEntity>>> call(String params) {
    return _repo.getAdRequests(id: params);
  }
}
