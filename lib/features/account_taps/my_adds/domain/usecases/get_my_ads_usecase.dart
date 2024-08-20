import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetMyAdsUseCase extends UseCase<List<AdEntity>, NoParams> {
  final MyAdsRepo _repo;
  GetMyAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdEntity>>> call(NoParams params) {
    return _repo.getAds();
  }
}
