import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/usecases/get_ad_properties_usecase.dart';
import 'package:fourtyninehub/features/ads_feature/filter_ads/data/models/filter_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';
import '../entities/ad_properties_entity.dart';

abstract class CreateAdRepo {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required GetAdPropertiesParams params,
  });
  Future<Either<Failure, bool>> creatAd({required AdModel ad});
  Future<Either<Failure, List<AdModel>>> filterAd({required FilterModel ad});
}
