import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/repositories/ad_details_repo.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetAdDetailsUseCase extends UseCase<AddDetailsModel, GetAdDetailsParams> {
  final AdDetailsRepo _repo;
  GetAdDetailsUseCase(this._repo);

  @override
  Future<Either<Failure, AddDetailsModel>> call(GetAdDetailsParams params) {
    return _repo.getAdDetails(params: params);
  }
}

class GetAdDetailsParams {
  final String userId;
  final String adId;

  GetAdDetailsParams({required this.userId, required this.adId});
}