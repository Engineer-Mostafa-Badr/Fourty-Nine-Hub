import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/Gift/gift_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_gift_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/request_withdraw_wallet_use_case.dart';

class GiftRepositoryImpl implements GiftRepository {
  final GiftRemoteDataSource _remoteDataSource;

  GiftRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, GiftWalletEntity>> fetchGiftWallet() {
    return _remoteDataSource.fetchGiftWallet();
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id) {
    return _remoteDataSource.requestWithdrawCompetition(id);
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawWheel() {
    return _remoteDataSource.requestWithdrawWheel();
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawWallet(
      RequestWithdrawParams params) {
    return _remoteDataSource.requestWithdrawWallet(params);
  }

  @override
  Future<Either<Failure, DataWinnersGiftEntity>> getWinnersGift(
      PaginationParams params) {
    return _remoteDataSource.getWinnersGift(params);
  }
}
