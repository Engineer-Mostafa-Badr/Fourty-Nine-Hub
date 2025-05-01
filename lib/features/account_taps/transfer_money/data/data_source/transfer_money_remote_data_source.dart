import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/data/model/transfer_money_model.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/data/model/user_transfer_money_model.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/transfer_money_entity.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/domain/use_case/fetch_user_use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/user_transfer_money_entity.dart';
import '../../domain/use_case/transfer_money_use_case.dart';

abstract class TransferMoneyRemoteDataSource {
  Future<Either<Failure, TransferMoneyEntity>> transferMoney(
      TransferMoneyParams params);
  Future<Either<Failure, List<UserTransferMoneyEntity>>> fetchUser(
      FetchUserParams params);
}

class TransferMoneyRemoteDataSourceImpl extends TransferMoneyRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TransferMoneyRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, TransferMoneyEntity>> transferMoney(
      TransferMoneyParams params) async {
    try {
      var response = await _apiConsumer.post(EndPoints.transferMoney,
          data: params.toJson());

      return response.fold(
        (failure) => Left(failure),
        (response) => Right(TransferMoneyModel.fromJson(response['data'])),
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<UserTransferMoneyEntity>>> fetchUser(
      FetchUserParams params) async {
    var response = await _apiConsumer
        .get(EndPoints.searchUsersByUsernameOrEmail(params.query));

    return response.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => UserTransferMoneyModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }
}
