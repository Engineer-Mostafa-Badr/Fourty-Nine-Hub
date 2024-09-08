import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/balance/request_withdraw_model.dart';

import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/balance/balance_history_entity.dart';
import '../../../domain/entities/balance/request_withdraw_entity.dart';
import '../../../domain/usecases/get_balance_history_use_case.dart';
import '../../models/balance/balance_data_model.dart';
import '../../models/balance/balance_history_model.dart';

abstract class BalanceRemoteDataSource {
  Future<Either<Failure, BalanceDataModel>> fetchBalance();

  Future<Either<Failure, List<BalanceHistoryEntity>>> fetchHistoryBalance(
      BalanceHistoryParams params);

  Future<Either<Failure, bool>> transferBalanceFiveYears();

  Future<Either<Failure, bool>> transferBalanceTenYears();

  Future<Either<Failure, bool>> requestWithdrawBalance();

  Future<Either<Failure, RequestWithdrawEntity>> checkRequestWithdrawBalance();
}

class BalanceRemoteDataSourceImpl extends BalanceRemoteDataSource {
  final ApiConsumer _apiConsumer;

  BalanceRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, BalanceDataModel>> fetchBalance() async {
    final response = await _apiConsumer.get(EndPoints.getBalance);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(BalanceDataModel.fromJson(response['data'])),
    );
  }

  @override
  Future<Either<Failure, List<BalanceHistoryModel>>> fetchHistoryBalance(
      BalanceHistoryParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getHistoryBalance(),
      queryParameters: params.paginationParams.toJson(),
    );
    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => BalanceHistoryModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, bool>> transferBalanceFiveYears() async {
    final response = await _apiConsumer.post(EndPoints.transferFiveBalance);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, bool>> transferBalanceTenYears() async {
    final response = await _apiConsumer.post(EndPoints.transferTenBalance);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawBalance() async {
    final response = await _apiConsumer.post(EndPoints.requestWithdrawBalance);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, RequestWithdrawEntity>>
      checkRequestWithdrawBalance() async {
    final response =
        await _apiConsumer.get(EndPoints.checkRequestWithdrawBalance);

  return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(RequestWithdrawModel.fromJson(response)),
    );
  }
}
