import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../entities/cache_out_entity/payout_method_entity.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class PayoutMethodBankUseCase extends UseCase<PayoutMethodEntity, NoParams> {
  final PaymentCacheOutRepository _repo;

  PayoutMethodBankUseCase(this._repo);

  @override
  Future<Either<Failure, PayoutMethodEntity>> call(NoParams params) async {
    return await _repo.payoutMethod();
  }
}
