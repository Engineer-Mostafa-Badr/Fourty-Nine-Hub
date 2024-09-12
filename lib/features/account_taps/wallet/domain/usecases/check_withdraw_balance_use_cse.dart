import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entities/balance/request_withdraw_entity.dart';
import '../repositories/balance_repository.dart';

class CheckRequestWithdrawUseCase extends UseCase<RequestWithdrawEntity,NoParams>{
  final BalanceRepository _balanceRepository;

  CheckRequestWithdrawUseCase(this._balanceRepository);

  @override
  Future<Either<Failure, RequestWithdrawEntity>> call(NoParams params) async{
    return await _balanceRepository.checkRequestWithdrawBalance();
  }

}