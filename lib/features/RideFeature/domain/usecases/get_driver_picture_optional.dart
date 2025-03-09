import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_picture_optional_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetDriverPictureOptionalUseCase
    extends UseCase<DriverPictureOptionalEntity, NoParams> {
  final RideRepository _repo;
  GetDriverPictureOptionalUseCase(this._repo);

  @override
  Future<Either<Failure, DriverPictureOptionalEntity>> call(NoParams params) {
    return _repo.getDriverPictureOptional();
  }
}
