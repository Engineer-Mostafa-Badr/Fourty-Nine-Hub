import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_request_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';

import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../domain/repositories/ad_details_repo.dart';
import '../datasources/ad_details_remote_data_source.dart';

class AdDetailsRepoImpl implements AdDetailsRepo {
  final AdDetailsRemoteDataSource _remoteDataSource;
  AdDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, AddDetailsModel>> getAdDetails({required String id}) async {
    return await _remoteDataSource.getAdDetails(id: id);
  }

  @override
  Future<Either<Failure, List<AdModel>>> getRelevantAds(
      {required int id}) async {
    return await _remoteDataSource.getRelevantAds(id: id);
  }

  @override
  Future<Either<Failure, bool>> makeAdRequest(
      {required AdRequestParams params}) {
    return _remoteDataSource.makeAdRequest(params: params);
  }
}
