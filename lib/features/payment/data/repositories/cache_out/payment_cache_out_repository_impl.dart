import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_cache_out_entity.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/cache_out/instapay_cache_out_use_case.dart';

import '../../../domain/repositories/cache_out/payment_cache_out_repository.dart';
import '../../data_source/cache_out/payment_cache_out_data_source.dart';

class PaymentCacheOutRepositoryImpl implements PaymentCacheOutRepository {
  final PaymentCacheOutRemoteDataSource remoteDataSource;

  PaymentCacheOutRepositoryImpl(this.remoteDataSource);


  @override
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(InstapayParams params) {
    return remoteDataSource.instapayCacheOut(params);
  }
}
