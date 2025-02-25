import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/check_driver_type_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/drivers_in_subcategory_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_not_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/register_ride_special_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetDriversInSubcategoryUseCase
    extends UseCase<List<DriversInSubcategoryEntity>, String> {
  final RideRepository _repo;
  GetDriversInSubcategoryUseCase(this._repo);

  @override
  Future<Either<Failure, List<DriversInSubcategoryEntity>>> call(String params) {
    return _repo.getDriversInSubcategory(params);
  }
}
