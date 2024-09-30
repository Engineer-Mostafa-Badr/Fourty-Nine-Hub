import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/Gift/gift_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class GiftRepositoryImpl implements GiftRepository {
  final GiftRemoteDataSource _remoteDataSource;

  GiftRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, GiftEntity>> fetchGiftWallet() {
    return _remoteDataSource.fetchGiftWallet();
  }
}
