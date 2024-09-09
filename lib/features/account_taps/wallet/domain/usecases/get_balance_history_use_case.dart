import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../repositories/balance_repository.dart';

class GetBalanceHistoryUseCase extends UseCase<List<BalanceHistoryEntity>, BalanceHistoryParams>{
  final BalanceRepository _balanceRepository;

  GetBalanceHistoryUseCase(this._balanceRepository);
  @override
  Future<Either<Failure, List<BalanceHistoryEntity>>> call(BalanceHistoryParams params) async{
    return await _balanceRepository.fetchHistoryBalance(params);
  }

}


class BalanceHistoryParams {
  PaginationParams paginationParams;

  BalanceHistoryParams({required this.paginationParams});

}