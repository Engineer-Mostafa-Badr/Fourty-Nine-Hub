import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/datasources/company_advertise_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_option_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/price_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/delete_company_ad_use_case.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/get_company_add_use_case.dart';

class CompanyAdvertiseRepositoryImpl implements CompanyAdvertiseRepository{
  final CompanyAdvertiseDataSource _advertiseDataSource;

  CompanyAdvertiseRepositoryImpl(this._advertiseDataSource);
  @override
  Future<Either<Failure, PriceEntity>> getPrice() {
    return _advertiseDataSource.getPrice();
  }

  @override
  Future<Either<Failure, List<CompanyAdOptionEntity>>> addCompanyAd(CompanyAddParams params) {
    return _advertiseDataSource.addCompanyAd(params);
  }

  @override
  Future<Either<Failure, bool>> deleteCompanyAd(DeleteCompanyAdParams params) {
    return _advertiseDataSource.deleteCompanyAd(params);
  }

}