import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';

import '../entities/balance/request_withdraw_entity.dart';
import '../entities/data_winners_cashback_entity.dart';
import '../usecases/get_balance_history_use_case.dart';
import '../usecases/get_winners_cashback_use_case.dart';

abstract class BalanceRepository {
  Future<Either<Failure, BalanceDataEntity>> fetchBalance();
  Future<Either<Failure, List<BalanceHistoryEntity>>> fetchHistoryBalance(
      BalanceHistoryParams params);
  Future<Either<Failure, bool>> transferBalanceFiveYears();
  Future<Either<Failure, bool>> transferBalanceTenYears();
  Future<Either<Failure, bool>> requestWithdrawBalance();
  Future<Either<Failure, RequestWithdrawEntity>> checkRequestWithdrawBalance();
  Future<Either<Failure, DataWinnersCashbackEntity>> getWinnersCashback( GetWinnersCashbackUseCaseParams params);
}
