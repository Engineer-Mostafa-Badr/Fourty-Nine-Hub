import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/balance/balance_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/balance_repository.dart';


class BalanceRepositoryImpl extends BalanceRepository{
  final BalanceRemoteDataSource _balanceRemoteDataSource;

  BalanceRepositoryImpl(this._balanceRemoteDataSource);
  @override
  Future<Either<Failure, BalanceDataEntity>> fetchBalance() {
  return _balanceRemoteDataSource.fetchBalance();
  }

}