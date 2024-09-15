import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/wallet/wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/add_subscribe_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/delete_subscription_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/main_category_use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/wallet/main_category_entity.dart';
import '../../domain/repositories/wallet_repo.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletRemoteDataSource _remoteDataSource;
  WalletRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, WalletModel>> getWallet() {
    return _remoteDataSource.getWallet();
  }

  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> fetchHistoryWallet(
      WalletHistoryParams params) {
    return _remoteDataSource.fetchHistoryWallet(params);
  }

  @override
  Future<Either<Failure, List<WalletSubscriptionEntity>>>
      fetchSubscriptionWallet() {
    return _remoteDataSource.fetchSubscriptionWallet();
  }

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchMainCategory(
      MainCategoryParams params) {
    return _remoteDataSource.fetchMainCategory(params);
  }

  @override
  Future<Either<Failure, List<MainCategoryWalletEntity>>> fetchSubCategory(
      MainCategoryParams params) {
    return _remoteDataSource.fetchSubCategory(params);
  }

  @override
  Future<Either<Failure, bool>> deleteSubscription(
      DeleteSubscriptionParams params) {
    return _remoteDataSource.deleteSubscription(params);
  }

  @override
  Future<Either<Failure, bool>> addSubscription(AddSubscriptionParams params) {
    return _remoteDataSource.addSubscription(params);
  }
}
