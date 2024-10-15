import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ad_details/domain/usecases/make_ad_request_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_details_model.dart';

import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../domain/repositories/ad_requests_repo.dart';
import '../datasources/ad_requests_remote_data_source.dart';

class AdRequestsRepoImpl implements AdRequestsRepo {
  final AdRequestsRemoteDataSource _remoteDataSource;
  AdRequestsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, AddDetailsModel>> getAdDetails(
      {required String id}) async {
    return await _remoteDataSource.getAdDetails(id: id);
  }

  @override
  Future<Either<Failure, List<AdModel>>> getRelevantAds(
      {required int id}) async {
    return await _remoteDataSource.getRelevantAds(id: id);
  }


}
