import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/data/datasources/create_ad_remote_datasource.dart';

import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/ad_properties_entity.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';

import '../../domain/repositories/create_ad_repo.dart';

class CreateAdRepoImpl implements CreateAdRepo {
  final CreateAdRemoteDatasource _remoteDatasource;
  CreateAdRepoImpl(this._remoteDatasource);
  @override
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties(
      {required String subCategoryId}) async {
    return await _remoteDatasource.getAdProperties(
        subCategoryId: subCategoryId);
  }

  @override
  Future<Either<Failure, bool>> creatAd({required AdModel ad}) {
    return _remoteDatasource.creatAd(ad: ad);
  }

  @override
  Future<Either<Failure, bool>> filterAd({required FilterModel ad}) {
    return _remoteDatasource.filterAd(ad: ad);
  }
}
