import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_token.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

class PayWithTokenseCase
    extends UseCase<PayWithTokenResponseEntity, PayWithTokenParams> {
  final PaymentProviderRepository _repo;
  PayWithTokenseCase(this._repo);
  @override

  Future<Either<Failure, PayWithTokenResponseEntity>> call(PayWithTokenParams params) async {
    return await _repo.payWithToken(params);
  }
}

class PayWithTokenParams{
  final String cardId;
  final String amountId;
  final String cvv;

  PayWithTokenParams({required this.cardId, required this.amountId, required this.cvv});
}