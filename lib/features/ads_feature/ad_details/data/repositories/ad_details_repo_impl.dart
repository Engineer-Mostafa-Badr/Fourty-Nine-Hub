import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../domain/repositories/ad_details_repo.dart';
import '../datasources/ad_details_remote_data_source.dart';

class AdDetailsRepoImpl implements AdDetailsRepo {
  final AdDetailsRemoteDataSource _remoteDataSource;
  AdDetailsRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, AdModel>> getAdDetails({required int id}) async {
    return await _remoteDataSource.getAdDetails(id: id);
  }
  
  @override
  Future<Either<Failure, List<AdModel>>> getRelevantAds({required int id})async {
   
   return await _remoteDataSource.getRelevantAds(id: id);
  }
}
