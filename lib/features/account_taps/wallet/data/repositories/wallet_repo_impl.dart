import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competition_entity.dart';

import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_entity.dart';

import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../domain/repositories/wallet_repo.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletRemoteDataSouce _remoteDataSouce;
  WalletRepoImpl(this._remoteDataSouce);
  @override
  Future<Either<Failure, List<CompetitionEntity>>> getCompetitions() {
    return _remoteDataSouce.getCompetitions();
  }

  @override
  Future<Either<Failure, WalletEntity>> getWallet() {
    return _remoteDataSouce.getWallet();
  }

  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory(
      {required WalletTypes type}) {
    return _remoteDataSouce.getWalletHistory(type: type);
  }
}
