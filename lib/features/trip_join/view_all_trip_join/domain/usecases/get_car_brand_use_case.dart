import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../RideFeature/domain/entities/ride_brand_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class GetCarBrandUseCase
    extends UseCase<List<RideBrandEntity>, CarBrandParams> {
  final ViewAllTripJoinRepo _repo;
  GetCarBrandUseCase(this._repo);

  @override
  Future<Either<Failure, List<RideBrandEntity>>> call(CarBrandParams params) {
    return _repo.getRideBrands(params);
  }
}

class CarBrandParams{
  final int page;
  final String? id;
  final int limit;

  CarBrandParams({required this.page, required this.limit,this.id});
}