import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/ad_properties_entity.dart';

abstract class CreateAdRepo {
  Future<Either<Failure, List<AdPropertiesEntity>>> getAdProperties({
    required String subCategoryId,
  }); 
}
