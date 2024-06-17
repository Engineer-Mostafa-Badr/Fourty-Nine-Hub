import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

abstract class AdsRepo {
  Future<Either<Failure, List<AdModel>>> getAds({
    required int subCategoryId
  });

}
