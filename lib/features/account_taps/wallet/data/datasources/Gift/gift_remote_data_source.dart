import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/gift_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/data_winners_gift_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/gift_wallet_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/data_winners_gift_entity.dart';
import '../../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/usecases/request_withdraw_wallet_use_case.dart';

abstract class GiftRemoteDataSource {
  Future<Either<Failure, GiftWalletModel>> fetchGiftWallet();
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id);
  Future<Either<Failure, bool>> requestWithdrawWheel();
  Future<Either<Failure, bool>> requestWithdrawWallet(
      RequestWithdrawParams params);
  Future<Either<Failure, DataWinnersGiftEntity>> getWinnersGift(
      PaginationParams params);
  Future<Either<Failure, GiftEntity>> testGift();
}

class GiftRemoteDataSourceImpl implements GiftRemoteDataSource {
  final ApiConsumer _apiConsumer;

  GiftRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, GiftWalletModel>> fetchGiftWallet() async {
    final response = await _apiConsumer.get(EndPoints.getGift);
    return response.fold((failure) => Left(failure),
        (response) => Right(GiftWalletModel.fromJson(response['data'])));
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id) async {
    final response =
        await _apiConsumer.post(EndPoints.requestWithdrawCompetition(id));

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawWheel() async {
    final response = await _apiConsumer.post(EndPoints.requestWithdrawWheel);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, GiftEntity>> testGift() async{
    final response = await _apiConsumer.get(EndPoints.testGift);
    return response.fold((failure) => Left(failure),
        (response) => Right(GiftModelModel.fromJson(response['data'])));
  }

  @override
  Future<Either<Failure, bool>> requestWithdrawWallet(
      RequestWithdrawParams params) async {
    final response = await _apiConsumer
        .post(EndPoints.requestWithdrawalMainWallet, data: params.toJson());

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, DataWinnersGiftEntity>> getWinnersGift(
      PaginationParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getWinnersGift(params),
    );
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(
        DataWinnersGiftModel.fromJson(response['data']),
      ),
    );
  }
}
