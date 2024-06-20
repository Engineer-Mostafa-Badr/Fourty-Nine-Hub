import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';

abstract class MyAdsRepo {
   Future<Either<Failure, List<AdEntity>>> getAds();
  Future<Either<Failure, bool>> cancelAd({required int id});
  Future<Either<Failure, bool>> deactivateAd({required int id});
}

