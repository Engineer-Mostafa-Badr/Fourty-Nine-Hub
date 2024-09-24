import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/account_taps/transfer_money/data/model/user_transfer_money_model.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entities/user_transfer_money_entity.dart';
import '../../domain/use_case/transfer_money_use_case.dart';

abstract class TransferMoneyRemoteDataSource {
  Future<Either<Failure, bool>> transferMoney(TransferMoneyParams params);
  Future<Either<Failure, List<UserTransferMoneyEntity>>> fetchUser();
}

class TransferMoneyRemoteDataSourceImpl extends TransferMoneyRemoteDataSource {
  final ApiConsumer _apiConsumer;

  TransferMoneyRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> transferMoney(
      TransferMoneyParams params) async {
    var response =
        await _apiConsumer.post(EndPoints.transferMoney, data: params.toJson());

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(response['status']),
    );
  }

  @override
  Future<Either<Failure, List<UserTransferMoneyEntity>>> fetchUser() async {
    var response = await _apiConsumer.get(EndPoints.fetchUsers);

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
