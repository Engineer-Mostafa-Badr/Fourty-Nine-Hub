import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/data/models/ride_brand_model.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideBrandsUseCase
    extends UseCase<List<RideBrandEntity>, NoParams> {
  final RideRepository _repo;
  GetRideBrandsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RideBrandEntity>>> call(NoParams params) {
    return _repo.getRideBrands();
  }
}
