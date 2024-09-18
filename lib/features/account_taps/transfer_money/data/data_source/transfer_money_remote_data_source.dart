import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/use_case/transfer_money_use_case.dart';

abstract class TransferMoneyRemoteDataSource {
  Future<Either<Failure, bool>> transferMoney(TransferMoneyParams params);
}

class TransferMoneyRemoteDataSourceImpl extends TransferMoneyRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TransferMoneyRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> transferMoney(
      TransferMoneyParams params) async {
    var response =
        await _apiConsumer.post(EndPoints.transferMoney, data: params.toJson());

   return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(response['status']),
    );
  }
}
