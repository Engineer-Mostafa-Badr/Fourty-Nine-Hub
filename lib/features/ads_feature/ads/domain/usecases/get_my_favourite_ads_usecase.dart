import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/usecases/get_my_ad_by_id_usecase.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/Ad_model.dart';
import '../repositories/ads_repo.dart';

class GetMyFavouriteAdsUsecase extends UseCase<List<AdModel>, GetMyAdByIdParams> {
  final AdsRepo _repo;

  GetMyFavouriteAdsUsecase(this._repo);

  @override
  Future<Either<Failure, List<AdModel>>> call(GetMyAdByIdParams params) {
    return _repo.getMyAdFavouriteAds(params);
  }
}
