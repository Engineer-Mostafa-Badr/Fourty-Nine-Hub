import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/gift_model.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import '../../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../../../core/error/failure.dart';

abstract class GiftRemoteDataSource {
  Future<Either<Failure, GiftModelModel>> fetchGiftWallet();
  Future<Either<Failure, bool>> requestWithdrawCompetition(String id);
  Future<Either<Failure, bool>> requestWithdrawWheel();
  Future<Either<Failure, GiftEntity>> testGift();
}

class GiftRemoteDataSourceImpl implements GiftRemoteDataSource {
  final ApiConsumer _apiConsumer;

  GiftRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, GiftModelModel>> fetchGiftWallet() async {
    final response = await _apiConsumer.get(EndPoints.getGift);
    return response.fold((failure) => Left(failure),
        (response) => Right(GiftModelModel.fromJson(response['data'])));
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
}
