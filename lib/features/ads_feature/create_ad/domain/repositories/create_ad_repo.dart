import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';
import '../entities/ad_properties_entity.dart';

abstract class CreateAdRepo {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required String subCategoryId,
  });
  Future<Either<Failure, bool>> creatAd({required AdModel ad});
  Future<Either<Failure, List<AdModel>>> filterAd({required FilterModel ad});
}
