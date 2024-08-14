import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetAdDetailsUseCase extends UseCase<AdModel, String> {
  final AdDetailsRepo _repo;
  GetAdDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, AdModel>> call(String params) {
    return _repo.getAdDetails(id: params);
  }
}
