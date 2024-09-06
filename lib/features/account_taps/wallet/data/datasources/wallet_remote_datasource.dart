import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/usecases/get_wallet_history_use_case.dart';
import '../models/wallet/wallet_history_model.dart';
import '../models/wallet/wallet_model.dart';


abstract class WalletRemoteDataSource {
  Future<Either<Failure, WalletModel>> getWallet();
  Future<Either<Failure,List<WalletHistoryEntity>>>fetchHistoryWallet(WalletHistoryParams params);
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

  @override
  Future<Either<Failure, List<WalletHistoryEntity>>> fetchHistoryWallet(WalletHistoryParams params) async{
    final response =
    await _apiConsumer.get(EndPoints.getHistoryWallet(params));
    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data'] as List)
          .map((e) => WalletHistoryModel.fromJson(e))
          .toList();
      return Right(list);
    });
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
