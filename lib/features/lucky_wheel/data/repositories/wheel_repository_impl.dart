import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/lucky_wheel/data/data_sources/wheel_remote_data_source.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';

import '../../domain/repositories/wheel_repository.dart';

class WheelRepositoryImpl extends WheelRepository {
  final WheelRemoteDataSource _remoteDataSource;

  WheelRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, WheelEntity>> getWheel() {
    return _remoteDataSource.getWheel();
  }

  @override
  Future<Either<Failure, WheelItemEntity>> spinWheel(String id) {
    return _remoteDataSource.spinWheel(id);
  }

  @override
  Future<Either<Failure, WheelWalletEntity>> getWheelWallet() {
    return _remoteDataSource.getWheelWallet();
  }
}
