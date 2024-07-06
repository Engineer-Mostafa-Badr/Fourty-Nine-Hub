import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../entities/competition_entity.dart';
import '../entities/wallet_entity.dart';
import '../entities/wallet_history_entity.dart';

abstract class WalletRepo {
  Future<Either<Failure, WalletEntity>> getWallet();
  Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory({
    required WalletTypes type
  });
  Future<Either<Failure, List<CompetitionEntity>>> getCompetitions();
}