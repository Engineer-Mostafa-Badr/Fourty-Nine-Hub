import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/ads_repo.dart';

class RemoveFavouriteAdUseCase extends UseCase<bool, String> {
  final AdsRepo _repo;
  RemoveFavouriteAdUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.removeFavouriteAd(params: params);
  }
}
