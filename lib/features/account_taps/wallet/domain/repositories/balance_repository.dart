import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';

import '../usecases/get_balance_history_use_case.dart';

abstract class BalanceRepository{
  Future<Either<Failure,BalanceDataEntity>>fetchBalance();
  Future<Either<Failure,List<BalanceHistoryEntity>>>fetchHistoryBalance(BalanceHistoryParams params);
}