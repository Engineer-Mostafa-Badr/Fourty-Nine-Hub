import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/transfer_money_use_case.dart';

import '../../domain/entities/user_transfer_money_entity.dart';
import '../../domain/repository/transfer_money_repository.dart';
import '../data_source/transfer_money_remote_data_source.dart';


class TransferMoneyRepositoryImpl extends TransferMoneyRepository{
  final TransferMoneyRemoteDataSource _transferMoneyRemoteDataSource;

  TransferMoneyRepositoryImpl(this._transferMoneyRemoteDataSource);

  @override
  Future<Either<Failure, bool>> transferMoney(TransferMoneyParams params) {
    return _transferMoneyRemoteDataSource.transferMoney(params);
  }

  @override
  Future<Either<Failure, List<UserTransferMoneyEntity>>> fetchUser() {
    return _transferMoneyRemoteDataSource.fetchUser();
  }
}