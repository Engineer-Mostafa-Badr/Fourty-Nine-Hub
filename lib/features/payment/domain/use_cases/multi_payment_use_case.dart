import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_multi_payment_response.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

class MutliPaymentUseCase
    extends UseCase<MutliPaymentResponse, MutliPaymentParams> {
  final PaymentProviderRepository _repo;

  MutliPaymentUseCase(this._repo);

  @override
  Future<Either<Failure, MutliPaymentResponse>> call(
      MutliPaymentParams params) async {
    return await _repo.makeMultiPayment(params);
  }
}

class MutliPaymentParams {
  final String amountId;
  final String providerId;
  final String paymentMethod;

  MutliPaymentParams({
    required this.amountId,
    required this.providerId,
    required this.paymentMethod,
  });
}
