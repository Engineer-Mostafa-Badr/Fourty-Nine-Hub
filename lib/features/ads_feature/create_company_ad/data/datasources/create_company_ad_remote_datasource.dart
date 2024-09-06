import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/assets/jsons.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../models/company_ad_option_model.dart';

abstract class CreateCompanyAdRemoteDataSource {
  Future<Either<Failure, List<CompanyAdOptionEntity>>> getCompanyAdsOptions();
}

class CreateCompanyAdRemoteDataSourceImpl
    implements CreateCompanyAdRemoteDataSource {
  final JsonParser _apiConsumer;
  CreateCompanyAdRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<CompanyAdOptionEntity>>> getCompanyAdsOptions() async {
    final response = await _apiConsumer.get(Jsons.companyAds);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => CompanyAdOptionModel.fromJson(e))
            .toList()));
  }
}
