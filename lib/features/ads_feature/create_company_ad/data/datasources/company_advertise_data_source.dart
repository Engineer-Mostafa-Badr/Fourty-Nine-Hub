import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/price_model.dart';

abstract class CompanyAdvertiseDataSource {
  Future<Either<Failure, PriceModel>> getPrice();
}

class CompanyAdvertiseDataSourceImpl implements CompanyAdvertiseDataSource {
  final ApiConsumer _apiConsumer;

  CompanyAdvertiseDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, PriceModel>> getPrice() async {
    final response = await _apiConsumer.get(EndPoints.getPrice);
   return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(PriceModel.fromJson(response['data'])),
    );
  }
}
