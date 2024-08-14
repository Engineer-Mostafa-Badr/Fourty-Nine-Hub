import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRelevantAdsUseCase extends UseCase<List<AdModel>, int> {
  final AdDetailsRepo _repo;
  GetRelevantAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdModel>>> call(int params) {
    return _repo.getRelevantAds(id: params);
  }
}
