import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/balance/balance_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/balance_repository.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_history_use_case.dart';


class BalanceRepositoryImpl extends BalanceRepository{
  final BalanceRemoteDataSource _balanceRemoteDataSource;

  BalanceRepositoryImpl(this._balanceRemoteDataSource);
  @override
  Future<Either<Failure, BalanceDataEntity>> fetchBalance() {
  return _balanceRemoteDataSource.fetchBalance();
  }

  @override
  Future<Either<Failure, List<BalanceHistoryEntity>>> fetchHistoryBalance(BalanceHistoryParams params) {
    return _balanceRemoteDataSource.fetchHistoryBalance(params);
  }

}