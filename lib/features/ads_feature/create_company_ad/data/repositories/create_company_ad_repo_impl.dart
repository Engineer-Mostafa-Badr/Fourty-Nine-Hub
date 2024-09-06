import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/repositories/create_company_ad_repo.dart';
import '../datasources/create_company_ad_remote_datasource.dart';

class CreateCompanyAdRepoImpl implements CreateCompanyAdRepo {
  final CreateCompanyAdRemoteDataSource _remoteDataSource;
  CreateCompanyAdRepoImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<CompanyAdOptionEntity>>> getCompanyAdsOptions() {
    return _remoteDataSource.getCompanyAdsOptions();
  }
}
