import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../entities/cache_out_entity/price_yellow_card_entity.dart';
import '../../repositories/cache_out/payment_cache_out_repository.dart';

class FetchPriceYellowUseCase extends UseCase<PriceYellowCardEntity, NoParams> {
  final PaymentCacheOutRepository _repo;

  FetchPriceYellowUseCase(this._repo);

  @override
  Future<Either<Failure, PriceYellowCardEntity>> call(NoParams params) async {
    return await _repo.fetchPrice();
  }
}
