import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/fawry_card_token_response_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

class FawrySaveCardTokenUseCase extends UseCase<FawryCardTokenResponseEntity, FawrySaveCardTokenParams> {
  final PaymentProviderRepository _repo;

  FawrySaveCardTokenUseCase(this._repo);

  @override
  Future<Either<Failure, FawryCardTokenResponseEntity>> call(FawrySaveCardTokenParams params) async {
    return await _repo.saveCardToken(params);
  }
}
class FawrySaveCardTokenParams {
  final String cardNumber;
  final String cardExpiryYear;
  final String cardExpiryMonth;
  final String cardAlias;
  final String cvv;

  FawrySaveCardTokenParams({
    required this.cardNumber,
    required this.cardExpiryYear,
    required this.cardExpiryMonth,
    required this.cardAlias,
    required this.cvv,
  });
}
