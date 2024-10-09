import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../entities/cache_out_entity/list_bank_entity.dart';
import '../../entities/cache_out_entity/price_yellow_card_entity.dart';
import '../../entities/instapay_cache_out_entity.dart';
import '../../use_cases/cache_out/instapay_cache_out_use_case.dart';
import '../../use_cases/cache_out/pay_out_request_use_case.dart';
import '../../use_cases/cache_out/request_instapay_use_case.dart';
import '../../use_cases/cache_out/request_yellow_card_use_case.dart';

abstract class PaymentCacheOutRepository {
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(
      InstapayParams params);
  Future<Either<Failure, bool>> requestYellowCard(
      RequestYellowCardParams params);

  Future<Either<Failure,List<ListBankEntity>>>fetchAllBank();
  Future<Either<Failure,bool>>payoutRequest(PayoutRequestParams params);
  Future<Either<Failure,bool>> requestInstapay(RequestInstapayParams params);
  Future<Either<Failure,PriceYellowCardEntity>>fetchPrice();
}
