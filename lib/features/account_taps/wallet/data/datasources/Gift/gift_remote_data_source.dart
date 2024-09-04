import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/gift_wallet_model.dart';

import '../../../../../../core/api/api_consumer.dart';
import '../../../../../../core/api/end_points.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/gift_entities.dart';
import '../../models/Gift/competition_wallet_model.dart';

abstract class GiftRemoteDataSource{
  Future<Either<Failure,GiftWallet>> fetchGiftWallet();
  Future<Either<Failure,List<CompetitionWallet>>> fetchCompetitionsWallet();
}

class GiftRemoteDataSourceImpl implements GiftRemoteDataSource{
  final ApiConsumer _apiConsumer;

  GiftRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<CompetitionWallet>>> fetchCompetitionsWallet()async {
    final response = await _apiConsumer.get(EndPoints.getGift);
    return response.fold(
            (failure) => Left(failure),
            (response) => Right((response['data']['competitionsWallet'] as List)
            .map((e) => CompetitionWalletModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, GiftWallet>> fetchGiftWallet() async{
    final response = await _apiConsumer.get(EndPoints.getGift);
    return response.fold(
            (failure) => Left(failure),
            (response) => Right(GiftWalletModel.fromJson(response)));
  }
}