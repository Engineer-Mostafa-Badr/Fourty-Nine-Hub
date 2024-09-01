import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';
import 'package:fourtyninehub/features/payment/domain/repositories/payment_provider_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetPaymentProviderUseCase
    extends UseCase<List<PaymentProviderEntity>, NoParams> {
  final PaymentProviderRepository _repo;
  GetPaymentProviderUseCase(this._repo);
  @override
  Future<Either<Failure, List<PaymentProviderEntity>>> call(
      NoParams params) async {
    return await _repo.getPaymentProvider();
  }
}
