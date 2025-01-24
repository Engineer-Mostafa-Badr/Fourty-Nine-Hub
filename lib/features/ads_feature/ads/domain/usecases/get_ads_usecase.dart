import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/ads_repo.dart';

class GetAdsUseCase extends UseCase<List<AdModel>, GetAdsParams> {
  final AdsRepo _repo;
  GetAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdModel>>> call(GetAdsParams params) {
    return _repo.getAds(params: params);
  }
}

class GetAdsParams {
  final String subCategoryId;
  String? filter;
  final int page;
  final int limit;
  final String? userId;

  GetAdsParams(
      {required this.subCategoryId,
        this.filter,
      required this.page,
      this.userId,
      required this.limit});
  Map<String, dynamic> toJson() => {
        'subCategoryId': subCategoryId,
        if(filter != null)'filter': filter,
        'page': page,
        'limit': limit,
        if (userId != null) 'userId': limit,
      };
}
