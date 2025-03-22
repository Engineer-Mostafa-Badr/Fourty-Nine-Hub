import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class MakeRequestTripUseCase
    extends UseCase<bool, NoParams> {
  final RideRepository _repo;
  MakeRequestTripUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return _repo.makeRequestTrip();
  }
}
