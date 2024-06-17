import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/repositories/ads_repo.dart';

import '../datasources/ads_remote_data_source.dart';

class AdsRepoImpl implements AdsRepo {
  final AdsRemoteDataSource _remoteDataSource;
  AdsRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AdModel>>> getAds(
      {required int subCategoryId}) async {
    return await _remoteDataSource.getAds(subCategoryId: subCategoryId);
  }
}
