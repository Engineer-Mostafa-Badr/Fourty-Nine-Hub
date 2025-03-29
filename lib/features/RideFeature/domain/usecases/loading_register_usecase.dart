import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_register_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class LoadingRegisterUseCase
    extends UseCase<bool, LoadingRegisterEntity> {
  final RideRepository _repo;
  LoadingRegisterUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(LoadingRegisterEntity params) {
    return _repo.loadingRegister(params);
  }
}
