import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/lucky_wheel/domain/entities/wheel_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/wheel_repository.dart';

class GetWheelUseCase extends UseCase<WheelEntity, NoParams> {
  final WheelRepository repository;

  GetWheelUseCase(this.repository);

  @override
  Future<Either<Failure, WheelEntity>> call(NoParams params) {
    return repository.getWheel();
  }
}
