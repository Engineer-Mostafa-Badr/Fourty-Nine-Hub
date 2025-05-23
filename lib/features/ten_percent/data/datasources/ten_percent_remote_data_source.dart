import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ten_percent/data/model/winners_ten_percent_model.dart';
import 'package:fourtyninehub/features/ten_percent/domain/entities/winners_ten_percent_entity.dart';
import 'package:fourtyninehub/features/ten_percent/domain/usecases/get_winners_ten_percent_use_case.dart';
import 'package:fourtyninehub/features/ten_percent/domain/usecases/send_bill_request_use_case.dart';

abstract class TenPercentRemoteDataSource {
  Future<Either<Failure, bool>> sendBillRequest(
      {required SentBillRequestParams params});

  Future<Either<Failure, WinnersTenPercentEntity>> getWinnersTenPercent(
      {required GetWinnersTenPercentParams params});
}

class TenPercentRemoteDataSourceImpl extends TenPercentRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TenPercentRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, bool>> sendBillRequest(
      {required SentBillRequestParams params}) async {
    final response =
        await _apiConsumer.post(EndPoints.tenPercent, data: params.toJson());

    return response.fold((failure) => Left(failure), (data) {
      return Right(data['status']);
    });
  }

  @override
  Future<Either<Failure, WinnersTenPercentEntity>> getWinnersTenPercent(
      {required GetWinnersTenPercentParams params}) async {
    try {
      final response = await _apiConsumer
          .get(EndPoints.getWinnersTenPercent(params: params));

      return response.fold((failure) => Left(failure), (data) {
        return Right(WinnersTenPercentModel.fromJson(data['data']));
      });
    } catch (e) {
      print(e.toString());
      return Left(
        UnknownFailure(e.toString()),
      );
    }
  }
}
