import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/wallet_repo.dart';

class GetWalletHistoryUseCase
    extends UseCase<List<WalletHistoryEntity>, WalletTypes> {
  final WalletRepo _repo;
  GetWalletHistoryUseCase(this._repo);
  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> call(WalletTypes params) {
    return _repo.getWalletHistory(type: params);
  }
}
