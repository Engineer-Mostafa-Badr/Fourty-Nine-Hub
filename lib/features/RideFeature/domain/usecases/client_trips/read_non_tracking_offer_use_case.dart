import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/ride_repository.dart';

class ReadNonTrackingOfferUseCase extends UseCase<bool, String> {
  final RideRepository _repo;
  ReadNonTrackingOfferUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return _repo.readNonTrackingOffer(params);
  }
}
