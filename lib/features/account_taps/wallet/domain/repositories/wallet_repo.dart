import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/wallet/wallet_entity.dart';
import '../entities/wallet/wallet_history_entity.dart';
import '../entities/wallet/wallet_subscription_entity.dart';
import '../usecases/get_wallet_history_use_case.dart';

abstract class WalletRepo {
  Future<Either<Failure, WalletEntity>> getWallet();
  Future<Either<Failure,List<WalletHistoryEntity>>>fetchHistoryWallet(WalletHistoryParams params);
  Future<Either<Failure,List<WalletSubscriptionEntity>>>fetchSubscriptionWallet();
}
