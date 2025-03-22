import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_request_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class MakeAdPremiumRequestUsecase extends UseCase<bool, AdRequestParams> {
  final AdDetailsRepo _repo;
  MakeAdPremiumRequestUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(AdRequestParams params) {
    return _repo.makeAdPremiumRequest(params: params);
  }
}
