import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/price_entity.dart';

import '../entities/company_ad_option_entity.dart';
import '../usecases/get_company_add_use_case.dart';

abstract class CompanyAdvertiseRepository{
  Future<Either<Failure,PriceEntity>>getPrice();
  Future<Either<Failure,List<CompanyAdOptionEntity>>>addCompanyAd(CompanyAddParams params);
}