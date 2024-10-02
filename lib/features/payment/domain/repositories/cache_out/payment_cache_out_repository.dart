import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../entities/instapay_cache_out_entity.dart';
import '../../use_cases/cache_out/instapay_cache_out_use_case.dart';

abstract class PaymentCacheOutRepository {
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(
      InstapayParams params);
}
