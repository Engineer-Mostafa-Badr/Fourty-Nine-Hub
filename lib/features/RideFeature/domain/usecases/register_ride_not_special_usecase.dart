import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class RegisterRideNotSpecialUseCase
    extends UseCase<bool, RegisterRideNotSpecialEntity> {
  final RideRepository _repo;
  RegisterRideNotSpecialUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(RegisterRideNotSpecialEntity params) {
    return _repo.registerRideNotSpecial(params);
  }
}
