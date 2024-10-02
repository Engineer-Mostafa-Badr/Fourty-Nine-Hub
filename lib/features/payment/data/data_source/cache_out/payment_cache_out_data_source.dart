import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/payment/data/models/instapay_cache_out_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/instapay_cache_out_entity.dart';
import '../../../domain/use_cases/cache_out/instapay_cache_out_use_case.dart';

abstract class PaymentCacheOutRemoteDataSource {
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(
      InstapayParams params);
}

class PaymentCacheOutRemoteDataSourceImpl
    implements PaymentCacheOutRemoteDataSource {
  final ApiConsumer _apiConsumer;
  PaymentCacheOutRemoteDataSourceImpl(this._apiConsumer);


  @override
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(InstapayParams params) async {
    final response = await _apiConsumer.put(
      EndPoints.instaPay,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right(InstapayCacheOutModel.fromJson(data));
      },
    );
  }
}
