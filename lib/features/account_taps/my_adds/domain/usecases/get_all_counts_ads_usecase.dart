import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/get_all_count_ads_entity.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class GetAllCountsAdsUseCase
    extends UseCase<List<GetAllCountAdsEntity>, CountAdsParams> {
  final MyAdsRepo _repo;
  GetAllCountsAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetAllCountAdsEntity>>> call(
      CountAdsParams params) {
    return _repo.getAllCountsAds(params);
  }
}

class CountAdsParams {
  final String id;
  final String status;

  CountAdsParams({required this.id, required this.status});
}
