import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/wallet_repo.dart';

class GetWalletUseCase extends UseCase<WalletEntity, NoParams> {
  final WalletRepo _repo;
  GetWalletUseCase(this._repo);
  @override
  Future<Either<Failure, WalletEntity>> call(NoParams params) {
    return _repo.getWallet();
  }
}
