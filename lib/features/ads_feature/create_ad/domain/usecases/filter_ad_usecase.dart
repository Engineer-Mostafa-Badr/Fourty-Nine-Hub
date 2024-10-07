import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import 'package:fourtyninehub/features/ads_feature/create_ad/domain/repositories/create_ad_repo.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';

class FilterAdUseCase extends UseCase<bool, FilterModel> {
  final CreateAdRepo _repo;

  FilterAdUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(
      FilterModel params,
  ) {
    return _repo.filterAd(ad: params);
  }
}
