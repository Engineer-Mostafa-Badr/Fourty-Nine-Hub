import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_competitions_entity.dart';
import '../../../../../core/error/failure.dart';
import '../entities/gift_and_competition_entity.dart';
import '../entities/wallet/main_category_entity.dart';
import '../entities/wallet/wallet_entity.dart';
import '../entities/wallet/wallet_history_entity.dart';
import '../entities/wallet/wallet_subscription_entity.dart';
import '../usecases/add_subscribe_use_case.dart';
import '../usecases/delete_subscription_use_case.dart';
import '../usecases/get_wallet_history_use_case.dart';
import '../usecases/main_category_use_case.dart';

abstract class WalletRepo {
  Future<Either<Failure, WalletEntity>> getWallet();
  Future<Either<Failure, List<WalletHistoryEntity>>> fetchHistoryWallet(
      WalletHistoryParams params);
  Future<Either<Failure, List<WalletSubscriptionEntity>>>
      fetchSubscriptionWallet();
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchMainCategory(
      MainCategoryParams params);
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchSubCategory(
      MainCategoryParams params);
  Future<Either<Failure, bool>> deleteSubscription(
      DeleteSubscriptionParams params);
  Future<Either<Failure, bool>> addSubscription(AddSubscriptionParams params);
  Future<Either<Failure, GiftAndCompetitionEntity>> getGiftCompetitions();
}
