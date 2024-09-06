import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/wallet_repo.dart';

import '../entities/wallet/wallet_history_entity.dart';
import '../repositories/balance_repository.dart';

class GetWalletHistoryUseCase extends UseCase<List<WalletHistoryEntity>, WalletHistoryParams>{
  final WalletRepo _walletRepo;

  GetWalletHistoryUseCase(this._walletRepo);
  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> call(WalletHistoryParams params) async{
    return await _walletRepo.fetchHistoryWallet(params);
  }

}


class WalletHistoryParams {
  final int page;
  final int limit;
  WalletHistoryParams({
    required this.page,
    required this.limit,
  });
  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
  };
}