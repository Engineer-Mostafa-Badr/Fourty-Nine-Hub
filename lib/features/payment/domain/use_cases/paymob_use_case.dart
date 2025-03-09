import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/payment/domain/entities/paymob_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class PaymobUseCase extends UseCase<PaymobEntity, PaymobParams> {
  final PaymentProviderRepository _repo;
  PaymobUseCase(this._repo);
  @override
  Future<Either<Failure, PaymobEntity>> call(PaymobParams params) async {
    return await _repo.getPaymob(params.amountId, params.providerId);
  }
}

class PaymobParams {
  final String amountId;
  final String providerId;

  PaymobParams({
    required this.amountId,
    required this.providerId,
  });
}
