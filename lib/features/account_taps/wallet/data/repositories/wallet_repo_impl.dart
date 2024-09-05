import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/wallet_model.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repo.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletRemoteDataSource _remoteDataSource;
  WalletRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, WalletModel>> getWallet() {
   return _remoteDataSource.getWallet();
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
