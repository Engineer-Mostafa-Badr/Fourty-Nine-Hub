import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';


abstract class PaymentProviderRepository {
  Future<Either<Failure, List<PaymentProviderEntity>>> getPaymentProvider();
}
