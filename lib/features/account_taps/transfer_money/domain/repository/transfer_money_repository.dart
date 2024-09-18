import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../use_case/transfer_money_use_case.dart';

abstract class TransferMoneyRepository{
  Future<Either<Failure,bool>> transferMoney(TransferMoneyParams params);
}