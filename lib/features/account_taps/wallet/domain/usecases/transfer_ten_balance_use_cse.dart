import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/balance_repository.dart';

class TransferTenBalanceUseCase extends UseCase<bool, NoParams> {
  final BalanceRepository _balanceRepository;

  TransferTenBalanceUseCase(this._balanceRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _balanceRepository.transferBalanceTenYears();
  }
}
