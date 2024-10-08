import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/payment/domain/entities/cache_out_entity/list_bank_entity.dart';
import 'package:fourtyninehub/features/payment/domain/entities/instapay_cache_out_entity.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/cache_out/instapay_cache_out_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/cache_out/pay_out_request_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/cache_out/request_instapay_use_case.dart';
import 'package:fourtyninehub/features/payment/domain/use_cases/cache_out/request_yellow_card_use_case.dart';

import '../../../domain/repositories/cache_out/payment_cache_out_repository.dart';
import '../../data_source/cache_out/payment_cache_out_data_source.dart';

class PaymentCacheOutRepositoryImpl implements PaymentCacheOutRepository {
  final PaymentCacheOutRemoteDataSource _remoteDataSource;

  PaymentCacheOutRepositoryImpl(this._remoteDataSource);


  @override
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(InstapayParams params) {
    return _remoteDataSource.instapayCacheOut(params);
  }

  @override
  Future<Either<Failure, bool>> requestYellowCard(RequestYellowCardParams params) {
   return _remoteDataSource.requestYellowCard(params);
  }

  @override
  Future<Either<Failure, List<ListBankEntity>>> fetchAllBank() {
    return _remoteDataSource.fetchAllBank();
  }

  @override
  Future<Either<Failure, bool>> payoutRequest(PayoutRequestParams params) {
    return _remoteDataSource.payoutRequest(params);
  }

  @override
  Future<Either<Failure, bool>> requestInstapay(RequestInstapayParams params) {
    return _remoteDataSource.requestInstapay(params);
  }
}
