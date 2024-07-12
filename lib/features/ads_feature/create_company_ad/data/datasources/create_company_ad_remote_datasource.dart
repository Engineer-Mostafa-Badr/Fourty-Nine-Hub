import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';

abstract class CreateCompanyAdRemoteDataSource {
  Future<Either<Failure, List<CompanyAdEntity>>> getCompanyAdsOptions();
}

class CreateCompanyAdRemoteDataSourceImpl
    implements CreateCompanyAdRemoteDataSource {
  final JsonParser _apiConsumer;
  CreateCompanyAdRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<CompanyAdEntity>>> getCompanyAdsOptions() async {
    final response = await _apiConsumer.get(Jsons.companyAds);
    return response.fold((l) => Left(l), (data) => Right((data['data'] as List).map((e) => CompanyAdModel.fromJson(e)).toList()));
  }
}
