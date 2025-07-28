import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class AddCarBrandUseCase
    extends UseCase<String, String> {
  final RideRepository _repo;
  AddCarBrandUseCase(this._repo);

  @override
  Future<Either<Failure, String>> call(String params) {
    return _repo.addCarBrand(params);
  }
}
