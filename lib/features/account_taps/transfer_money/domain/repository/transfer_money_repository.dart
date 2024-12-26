import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';

import '../entities/user_transfer_money_entity.dart';
import '../use_case/transfer_money_use_case.dart';

abstract class TransferMoneyRepository {
  Future<Either<Failure, TransferMoneyEntity>> transferMoney(
      TransferMoneyParams params);
  Future<Either<Failure, List<UserTransferMoneyEntity>>> fetchUser();
}
