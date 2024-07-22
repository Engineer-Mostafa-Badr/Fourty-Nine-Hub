import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../ads/data/models/Ad_model.dart';
import '../entities/ad_properties_entity.dart';

abstract class CreateAdRepo {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required String subCategoryId,
  }); 
    Future<Either<Failure, bool>> creatAd({required AdModel ad});

}
