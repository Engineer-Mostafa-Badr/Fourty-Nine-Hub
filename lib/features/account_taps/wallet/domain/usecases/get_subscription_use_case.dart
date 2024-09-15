import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/wallet_repo.dart';

class GetSubscriptionWalletUseCase
    extends UseCase<List<WalletSubscriptionEntity>, NoParams> {
  final WalletRepo _walletRepo;

  GetSubscriptionWalletUseCase(this._walletRepo);
  @override
  Future<Either<Failure, List<WalletSubscriptionEntity>>> call(
      NoParams params) async {
    return await _walletRepo.fetchSubscriptionWallet();
  }
}
