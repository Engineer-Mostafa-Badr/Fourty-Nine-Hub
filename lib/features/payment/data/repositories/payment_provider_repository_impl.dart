import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/data/data_source/payment_provider_data_source.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

class PaymentProviderRepositoryImpl implements PaymentProviderRepository{
final PaymentProviderRemoteDataSource remoteDataSource;

  PaymentProviderRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider() async{
    return await remoteDataSource.getPaymentProvider();

  }
}