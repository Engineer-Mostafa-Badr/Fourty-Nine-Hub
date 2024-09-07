import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/wallet/wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';

import '../../../../../core/error/failure.dart';
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
  Future<Either<Failure, List<WalletHistoryEntity>>> fetchHistoryWallet(WalletHistoryParams params) {
    return _remoteDataSource.fetchHistoryWallet(params);
  }

  @override
  Future<Either<Failure, List<WalletSubscriptionEntity>>> fetchSubscriptionWallet() {
    return _remoteDataSource.fetchSubscriptionWallet();
  }
  // @override
  // Future<Either<Failure, List<CompetitionEntity>>> getCompetitions() {
  //   return _remoteDataSouce.getCompetitions();
  // }


  //
  // @override
  // Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory(
  //     {required WalletTypes type}) {
  //   return _remoteDataSouce.getWalletHistory(type: type);
  // }
}
