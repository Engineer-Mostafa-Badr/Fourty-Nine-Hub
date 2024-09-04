import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/datasources/Gift/gift_remote_data_source.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

class GiftRepositoryImpl implements GiftRepository{
  final GiftRemoteDataSource remoteDataSource;

  GiftRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<CompetitionWallet>>> fetchCompetitionsWallet() {
    return remoteDataSource.fetchCompetitionsWallet();
  }

  @override
  Future<Either<Failure, GiftWallet>> fetchGiftWallet() {
    return remoteDataSource.fetchGiftWallet();
  }

}