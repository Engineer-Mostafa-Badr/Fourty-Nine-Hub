import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/balance_repository.dart';

import '../entities/balance/balance_data_entity.dart';

class GetBalanceUseCases extends UseCase<BalanceDataEntity,NoParams>{
 final BalanceRepository _balanceRepository;

  GetBalanceUseCases(this._balanceRepository);
  @override
  Future<Either<Failure,BalanceDataEntity>> call(NoParams params)async {
   return await _balanceRepository.fetchBalance();
  }

}