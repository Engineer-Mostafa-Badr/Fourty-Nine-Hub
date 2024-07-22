import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import 'package:fourtyninehub/features/ads_feature/create_ad/domain/repositories/create_ad_repo.dart';



class CreateAdUseCase
    extends UseCase<bool, AdModel> {
  final CreateAdRepo _repo;

  CreateAdUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(
    AdModel params,
  ) {
    return _repo.creatAd(ad: params);
  }
}
