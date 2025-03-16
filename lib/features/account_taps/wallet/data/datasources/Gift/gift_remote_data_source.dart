import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/gift_wallet_model.dart';
import '../../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/usecases/request_withdraw_wallet_use_case.dart';

abstract class GiftRemoteDataSource {
  Future<Either<Failure, GiftWalletModel>> fetchGiftWallet();
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id);
  Future<Either<Failure, bool>> requestWithdrawWheel();
  Future<Either<Failure, bool>> requestWithdrawWallet(RequestWithdrawParams params);
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
  Future<Either<Failure, bool>> requestWithdrawWallet(RequestWithdrawParams params) async{
    final response =
        await _apiConsumer.post(EndPoints.requestWithdrawalMainWallet, data: params.toJson());

    return response.fold(
          (failure) => Left(failure),
          (response) => Right(response['status']),
    );
  }
}
