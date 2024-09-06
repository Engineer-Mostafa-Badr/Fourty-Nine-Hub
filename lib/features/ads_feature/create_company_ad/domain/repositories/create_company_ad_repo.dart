import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/company_ad_option_entity.dart';

abstract class CreateCompanyAdRepo {
  Future<Either<Failure, List<CompanyAdOptionEntity>>> getCompanyAdsOptions();
}
