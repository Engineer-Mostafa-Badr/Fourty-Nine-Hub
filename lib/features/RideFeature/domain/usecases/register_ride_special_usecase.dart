import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class RegisterRideSpecialUseCase
    extends UseCase<bool, RegisterRideSpecialEntity> {
  final RideRepository _repo;
  RegisterRideSpecialUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(RegisterRideSpecialEntity params) {
    return _repo.registerRideSpecial(params);
  }
}
