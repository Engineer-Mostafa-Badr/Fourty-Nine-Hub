import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../models/wallet_model.dart';


abstract class WalletRemoteDataSource {
  Future<Either<Failure, WalletModel>> getWallet();
// Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory(
//     {required WalletTypes type});
// Future<Either<Failure, List<CompetitionEntity>>> getCompetitions();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiConsumer _apiConsumer;

  WalletRemoteDataSourceImpl(this._apiConsumer);

  @override
  // Future<Either<Failure, List<CompetitionEntity>>> getCompetitions() async {
  //   final response = await _apiConsumer.get(Jsons.competitionList);
  //   return response.fold(
  //       (l) => Left(l),
  //       (data) => Right((data['data']['items'] as List)
  //           .map((e) => CompetitionModel.fromJson(e))
  //           .toList()));
  // }

  @override
  Future<Either<Failure, WalletModel>> getWallet() async {
    final response = await _apiConsumer.get(EndPoints.getWallet);

   return response.fold(
      (failure)=>Left(failure),
      (response)=>Right(WalletModel.fromJson(response['data'])),
    );
  }

// @override
// Future<Either<Failure, List<WalletHistoryEntity>>> getWalletHistory(
//     {required WalletTypes type}) async {
//   String json = Jsons.walletHistoryList;
//   if (type == WalletTypes.balance) {
//     json = Jsons.balanceHistoryList;
//   } else if (type == WalletTypes.giftWallet) {
//     json = Jsons.giftHistoryList;
//   }
//   final response = await _apiConsumer.get(json);
//   return response.fold(
//       (l) => Left(l),
//       (data) => Right((data['data']['items'] as List)
//           .map((e) => WalletHistoryModel.fromJson(e))
//           .toList()));
// }
}
