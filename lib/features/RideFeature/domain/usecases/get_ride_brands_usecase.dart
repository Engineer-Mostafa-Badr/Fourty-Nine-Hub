import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideBrandsUseCase
    extends UseCase<List<String>, NoParams> {
  final RideRepository _repo;
  GetRideBrandsUseCase(this._repo);

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return _repo.getRideBrands();
  }
}
