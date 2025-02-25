import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class CheckDriverTypeUseCase
    extends UseCase<CheckDriverTypeEntity, NoParams> {
  final RideRepository _repo;
  CheckDriverTypeUseCase(this._repo);

  @override
  Future<Either<Failure, CheckDriverTypeEntity>> call(NoParams params) {
    return _repo.checkDriverType();
  }
}
