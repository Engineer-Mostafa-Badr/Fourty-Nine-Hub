import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/balance/balance_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/request_withdraw_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/balance_repository.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_winners_cashback_use_case.dart';

import '../../domain/entities/data_winners_cashback_entity.dart';

class BalanceRepositoryImpl extends BalanceRepository {
  final BalanceRemoteDataSource _balanceRemoteDataSource;

  BalanceRepositoryImpl(this._balanceRemoteDataSource);
  @override
  Future<Either<Failure, BalanceDataEntity>> fetchBalance() {
    return _balanceRemoteDataSource.fetchBalance();
  }

  @override
  Future<Either<Failure, List<BalanceHistoryEntity>>> fetchHistoryBalance(
      BalanceHistoryParams params) {
    return _balanceRemoteDataSource.fetchHistoryBalance(params);
  }

  @override
  Future<Either<Failure, bool>> transferBalanceFiveYears() {
    return _balanceRemoteDataSource.transferBalanceFiveYears();
  }

  @override
  Future<Either<Failure, bool>> transferBalanceTenYears() {
    return _balanceRemoteDataSource.transferBalanceTenYears();
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawBalance() {
    return _balanceRemoteDataSource.requestWithdrawBalance();
  }

  @override
  Future<Either<Failure, RequestWithdrawEntity>> checkRequestWithdrawBalance() {
    return _balanceRemoteDataSource.checkRequestWithdrawBalance();
  }

  @override
  Future<Either<Failure, DataWinnersCashbackEntity>> getWinnersCashback(GetWinnersCashbackUseCaseParams params) {
    return _balanceRemoteDataSource.getWinnersCashback(params);
  }
}
