import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/api_service.dart';

import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_advertise_model.dart';

import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_price_model.dart';

import '../../../../../../core/utils/shared_pref.dart';
import 'company_advertise_repo.dart';

class CompanyAdvertiseRepoImpl implements CompanyAdvertiseRepo {
  final ApiService apiService;

  CompanyAdvertiseRepoImpl(this.apiService);

  @override
  Future<Either<Failure, AdvertisePriceModel>> fetchPrice() async {
    try {
      String? accessToken = await TokenManager.getAccessToken();

      var data = await apiService.get(
          url: 'api/v1/advertisementCompany/price', token: accessToken);

      var advertisePrice = AdvertisePriceModel.fromJson(data);

      return right(advertisePrice);
    } on Exception catch (e) {
      // Handle general exceptions
      final failure = _mapExceptionToFailure(e);
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> addPostCompanyAdvertise(
      {List<String>? mediaIds,
      String? post,
      required String type,
      String? description,
      required int totalPrice}) async {
    try {
      String? accessToken = await TokenManager.getAccessToken();

      final Map<String, dynamic> jsonData = {
        "advertisements": [
          {
            "media": mediaIds,
            "post": post,
            "advertisement_type": type,
            "description": description,
            "totalPrice": totalPrice,
          }
        ]
      };
      await apiService.post(
          url: 'api/v1/advertisementCompany',
          token: accessToken,
          data: jsonData);

      // var advertiseCompany = AdvertiseCompanyModel.fromJson(data);

      return right(unit);
    } on Exception catch (e) {
      // Handle general exceptions
      final failure = _mapExceptionToFailure(e);
      return left(failure);
    }
  }

  Failure _mapExceptionToFailure(Exception e) {
    // Implement mapping from generic exception to Failure
    // For example, you might inspect the exception to determine the cause
    return ServerFailure(
      message: e.toString(),
      // Customize this based on the exception details
      statusCode: null,
      // You may need to extract status code from the exception if available
      errors: [e.toString()], // Customize this based on the exception details
    );
  }

  @override
  Future<Either<Failure, AdvertiseCompanyModel>> fetchPostCompanyAdvertise(
      String filter) async {
    try {
      String? accessToken = await TokenManager.getAccessToken();

      var data = await apiService.get(
          url: 'api/v1/advertisementCompany/my-advertisement?filter=$filter',
          token: accessToken,
          );

      var advertiseCompany = AdvertiseCompanyModel.fromJson(data);

      return right(advertiseCompany);
    } on Exception catch (e) {
      // Handle general exceptions
      final failure = _mapExceptionToFailure(e);
      return left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deletePosts(String id) async{
    try {
      String? accessToken = await TokenManager.getAccessToken();

       await apiService.delete(
        url: 'api/v1/advertisementCompany/$id',
        token: accessToken,
      );

      return right(unit);
    } on Exception catch (e) {
      final failure = _mapExceptionToFailure(e);
      return left(failure);
    }
  }
}
