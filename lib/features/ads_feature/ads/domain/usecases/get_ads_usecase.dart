import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/ads_repo.dart';

class GetAdsUseCase
    extends UseCase<List<AdModel>, int> {
  final AdsRepo _repo;
  GetAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdModel>>> call(int params) {
    return _repo.getAds(subCategoryId: params);
  }
}
