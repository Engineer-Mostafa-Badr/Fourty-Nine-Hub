import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_wallet_entity.dart';

abstract class WheelRepository {
  Future<Either<Failure, WheelEntity>> getWheel();
  Future<Either<Failure, WheelItemEntity>> spinWheel(String id);
  Future<Either<Failure, WheelWalletEntity>> getWheelWallet();
}
