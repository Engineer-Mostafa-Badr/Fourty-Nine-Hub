import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/datasources/company_advertise_data_source.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/price_entity.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/repositories/company_advertise_repository.dart';

class CompanyAdvertiseRepositoryImpl implements CompanyAdvertiseRepository{
  final CompanyAdvertiseDataSource _advertiseDataSource;

  CompanyAdvertiseRepositoryImpl(this._advertiseDataSource);
  @override
  Future<Either<Failure, PriceEntity>> getPrice() {
    return _advertiseDataSource.getPrice();
  }

}