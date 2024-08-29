import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/payment/data/models/payment_provider_model.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';

import '../../../../core/error/failure.dart';

abstract class PaymentProviderRemoteDataSource {
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider();

}

class PaymentProviderRemoteDataSourceImpl implements PaymentProviderRemoteDataSource {
  final ApiConsumer _apiConsumer;
  PaymentProviderRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider()async {
    final response = await _apiConsumer.get(EndPoints.getPaymentProvider);
    return response.fold(
            (failure) => Left(failure),
            (data) => Right((data['data'] as List)
            .map((e) => PaymentProviderModel.fromJson(e))
            .toList()));
  }



}
