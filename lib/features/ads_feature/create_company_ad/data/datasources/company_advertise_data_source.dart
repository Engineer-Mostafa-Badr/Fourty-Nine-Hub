import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/price_model.dart';

import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/usecases/delete_company_ad_use_case.dart';
import '../../domain/usecases/get_company_add_use_case.dart';
import '../models/company_ad_option_model.dart';

abstract class CompanyAdvertiseDataSource {
  Future<Either<Failure, PriceModel>> getPrice();

  Future<Either<Failure, List<CompanyAdOptionEntity>>> addCompanyAd(
      CompanyAddParams params);

  Future<Either<Failure, bool>> deleteCompanyAd(DeleteCompanyAdParams params);
}

class CompanyAdvertiseDataSourceImpl implements CompanyAdvertiseDataSource {
  final ApiConsumer _apiConsumer;

  CompanyAdvertiseDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, PriceModel>> getPrice() async {
    final response = await _apiConsumer.get(EndPoints.getPrice);
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(PriceModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, List<CompanyAdOptionEntity>>> addCompanyAd(
      CompanyAddParams params) async {
    final Map<String, dynamic> jsonData = {
      "advertisements": [
        {
          'post': params.post,
          'advertisement_type': params.advertisementType,
          'description': params.description,
          'totalPrice': params.totalPrice,
          'media': params.media?.isEmpty ?? false ? [] : params.media,
        }
      ]
    };

    final response = await _apiConsumer.post(
      EndPoints.postCompanyAd,
      data: jsonData,
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => CompanyAdOptionModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteCompanyAd(
      DeleteCompanyAdParams params) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteCompanyAd(params.id));

   return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(response['status']),
    );
  }
}
