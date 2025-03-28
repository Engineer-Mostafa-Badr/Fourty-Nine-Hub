import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/loading_info_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetLoadingInfoUseCase
    extends UseCase<LoadingInfoEntity, NoParams> {
  final RideRepository _repo;
  GetLoadingInfoUseCase(this._repo);

  @override
  Future<Either<Failure, LoadingInfoEntity>> call(NoParams params) {
    return _repo.getLoadingInfo();
  }
}
