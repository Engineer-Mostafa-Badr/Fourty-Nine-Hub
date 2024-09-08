import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';


import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/lucky_wheel/data/models/wheel_item_model.dart';
import 'package:fourtyninehub/features/lucky_wheel/data/models/wheel_model.dart';
import 'package:fourtyninehub/features/lucky_wheel/data/models/wheel_wallet_model.dart';

abstract class WheelRemoteDataSource {
  Future<Either<Failure, WheelModel>> getWheel();

  Future<Either<Failure, WheelItemModel>> spinWheel(String id);

  Future<Either<Failure, WheelWalletModel>> getWheelWallet();
}

class WheelRemoteDataSourceImpl implements WheelRemoteDataSource {
  final ApiConsumer _apiConsumer;

  WheelRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, WheelModel>> getWheel() async {
    final result = await _apiConsumer.get(EndPoints.getWheel);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        WheelModel.fromJson(
          response['data']['wheel'],
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, WheelItemModel>> spinWheel(String id) async {
    final result = await _apiConsumer.get('${EndPoints.spinWheel}$id');
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        WheelItemModel.fromJson(
          response['data'],
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, WheelWalletModel>> getWheelWallet() async {
    final result = await _apiConsumer.get(EndPoints.wheelWallet);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        WheelWalletModel.fromJson(
          response['data']['wallet'],
        ),
      ),
    );
  }
}
