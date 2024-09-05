import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance_data_entity.dart';

abstract class BalanceRepository{
  Future<Either<Failure,BalanceDataEntity>>fetchBalance();
}