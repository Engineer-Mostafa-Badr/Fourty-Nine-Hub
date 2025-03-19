import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideDriverInfoUseCase
    extends UseCase<DriverInfoEntity, NoParams> {
  final RideRepository _repo;
  GetRideDriverInfoUseCase(this._repo);

  @override
  Future<Either<Failure, DriverInfoEntity>> call(NoParams params) {
    return _repo.getRideDriverInfo();
  }
}
