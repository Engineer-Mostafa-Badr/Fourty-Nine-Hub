import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../entities/data_winners_cashback_entity.dart';
import '../repositories/balance_repository.dart';

class GetWinnersCashbackUseCase
    extends UseCase<DataWinnersCashbackEntity, GetWinnersCashbackUseCaseParams> {
  final BalanceRepository _balanceRepository;

  GetWinnersCashbackUseCase(this._balanceRepository);
  @override
  Future<Either<Failure, DataWinnersCashbackEntity>> call(
      GetWinnersCashbackUseCaseParams params) {
    return _balanceRepository.getWinnersCashback(params);
  }
}

class GetWinnersCashbackUseCaseParams {
  final int page;
  final int limit;

  GetWinnersCashbackUseCaseParams({required this.page, required this.limit});
}
