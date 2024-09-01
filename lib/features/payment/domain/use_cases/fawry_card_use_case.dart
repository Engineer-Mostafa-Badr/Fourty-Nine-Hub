import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_pay_with_card_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

class FawryCardUseCase extends UseCase<FawryPayWithCardEntity, FawryParams> {
  final PaymentProviderRepository _repo;

  FawryCardUseCase(this._repo);

  @override
  Future<Either<Failure, FawryPayWithCardEntity>> call(FawryParams params) async {
    return await _repo.chargeWithCard(params);
  }
}

class FawryParams {
  final String cardNumber;
  final String cardExpiryYear;
  final String cardExpiryMonth;
  final String cvv;
  final String amountId;
  final String providerId;
  final String paymentMethod;

  FawryParams({
    required this.cardNumber,
    required this.cardExpiryYear,
    required this.cardExpiryMonth,
    required this.cvv,
    required this.amountId,
    required this.providerId,
    required this.paymentMethod,
  });
}
