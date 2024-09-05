import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';

import '../../../../../../core/error/failure.dart';
import '../../models/balance/balance_data_model.dart';

abstract class BalanceRemoteDataSource {
  Future<Either<Failure, BalanceDataModel>> fetchBalance();
}

class BalanceRemoteDataSourceImpl extends BalanceRemoteDataSource {
  final ApiConsumer _apiConsumer;

  BalanceRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BalanceDataModel>> fetchBalance() async {
    final response = await _apiConsumer.get(EndPoints.getBalance);

   return response.fold(
      (failure)=>Left(failure),
      (response)=> Right(BalanceDataModel.fromJson(response['data'])),
    );
  }
}
