import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/json_parser.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/competition_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/competition_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_history_entity.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/assets/jsons.dart';
import '../models/wallet_history_model.dart';

abstract class WalletRemoteDataSouce {
  Future<Either<Failure, WalletEntity>> getWallet();
  Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory(
      {required WalletTypes type});
  Future<Either<Failure, List<CompetitionEntity>>> getCompetitions();
}

class WalletRemoteDataSouceImpl implements WalletRemoteDataSouce {
  final JsonParser _apiConsumer;
  WalletRemoteDataSouceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<CompetitionEntity>>> getCompetitions() async {
    final response = await _apiConsumer.get(Jsons.competitionList);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['items'] as List)
            .map((e) => CompetitionModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, WalletEntity>> getWallet() {
    // TODO: implement getWallet
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory(
      {required WalletTypes type}) async {
    String json = Jsons.walletHistoryList;
    if (type == WalletTypes.balance) {
      json = Jsons.balanceHistoryList;
    } else if (type == WalletTypes.giftWallet) {
      json = Jsons.giftHistoryList;
    }
    final response = await _apiConsumer.get(json);
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['items'] as List)
            .map((e) => WalletHistoryModel.fromJson(e))
            .toList()));
  }
}
