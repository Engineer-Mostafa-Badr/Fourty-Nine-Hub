import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/payment/data/models/cache_out_model/list_bank_model.dart';
import 'package:fourtyninehub/features/payment/data/models/instapay_cache_out_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/cache_out_entity/list_bank_entity.dart';
import '../../../domain/entities/instapay_cache_out_entity.dart';
import '../../../domain/use_cases/cache_out/instapay_cache_out_use_case.dart';
import '../../../domain/use_cases/cache_out/request_yellow_card_use_case.dart';

abstract class PaymentCacheOutRemoteDataSource {
  Future<Either<Failure, InstapayCacheOutEntity>> instapayCacheOut(
      InstapayParams params);
  Future<Either<Failure, bool>> requestYellowCard(
      RequestYellowCardParams params);
  Future<Either<Failure,List<ListBankEntity>>>fetchAllBank();
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

  @override
  Future<Either<Failure, bool>> requestYellowCard(RequestYellowCardParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.requestYellowCard,
      data: params.toJson(),
    );
    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right(data['status']);
      },
    );
  }

  @override
  Future<Either<Failure, List<ListBankEntity>>> fetchAllBank() async {
    final response = await _apiConsumer.get(
      EndPoints.banks,
    );
    return response.fold(
          (failure) => Left(failure),
          (data) {
        return Right((data['data'] as List)
            .map((e) => ListBankModel.fromJson(e))
            .toList());
      },
    );
  }
}
