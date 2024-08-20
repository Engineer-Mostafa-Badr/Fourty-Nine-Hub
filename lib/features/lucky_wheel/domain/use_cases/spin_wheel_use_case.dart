import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_item_entity.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/repositories/wheel_repository.dart';

import '../../../../core/error/failure.dart';

class SpinWheelUseCase extends UseCase<WheelItemEntity, String> {
  final WheelRepository _repository;

  SpinWheelUseCase(this._repository);

  @override
  Future<Either<Failure, WheelItemEntity>> call(String params) {
    return _repository.spinWheel(params);
  }
}
