import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_ad_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/price_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/usecases/pay_company_ad_use_case.dart';

import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../domain/entities/company_ad_entity.dart';
import '../../domain/entities/company_ad_option_entity.dart';
import '../../domain/usecases/delete_company_ad_use_case.dart';
import '../../domain/usecases/get_company_add_use_case.dart';
import '../models/company_ad_option_model.dart';
import '../models/fetch_post_company_advertise_params.dart';

abstract class CompanyAdvertiseDataSource {
  Future<Either<Failure, PriceModel>> getPrice();

  Future<Either<Failure, CompanyAdOptionEntity>> addCompanyAd(
      CompanyAddParams params);

  Future<Either<Failure, bool>> deleteCompanyAd(DeleteCompanyAdParams params);

  Future<Either<Failure, List<CompanyAdEntity>>> getPostCompanyAd(
      FetchPostCompanyAdvertiseParams params);

  Future<Either<Failure, bool>> payCompanyAd(PayCompanyAdParams params);
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
  Future<Either<Failure, CompanyAdOptionEntity>> addCompanyAd(
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
      EndPoints.postCompanyAd(),
      data: jsonData,
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right(CompanyAdOptionModel.fromJson(response));
        // return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteCompanyAd(
      DeleteCompanyAdParams params) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteCompanyAd(params.id));

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, List<CompanyAdEntity>>> getPostCompanyAd(
      FetchPostCompanyAdvertiseParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.getPostsCompanyAd(params));

    return response.fold(
      (failure) => Left(failure),
      (response) => Right((response['data']['advertises'] as List)
          .map((e) => CompanyAdModel.fromJson(e))
          .toList()),
    );
  }

  @override
  Future<Either<Failure, bool>> payCompanyAd(params) async {
    final response =
        await _apiConsumer.post(EndPoints.payCompanyAd, data: params.toJson());

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }
}
