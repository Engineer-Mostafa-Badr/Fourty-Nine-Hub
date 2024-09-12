import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/wallet_repo.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../entities/wallet/wallet_history_entity.dart';

class GetWalletHistoryUseCase extends UseCase<List<WalletHistoryEntity>, WalletHistoryParams>{
  final WalletRepo _walletRepo;

  GetWalletHistoryUseCase(this._walletRepo);
  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> call(WalletHistoryParams params) async{
    return await _walletRepo.fetchHistoryWallet(params);
  }

}


class WalletHistoryParams {
 final PaginationParams paginationParams;

  WalletHistoryParams({required this.paginationParams});
}