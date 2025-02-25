import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/car_years_and_types_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_statistics_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_color_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class GetRideCarColorsUseCase extends UseCase<List<RideColorEntity>, NoParams> {
  final RideRepository _repo;
  GetRideCarColorsUseCase(this._repo);

  @override
  Future<Either<Failure, List<RideColorEntity>>> call(NoParams params) {
    return _repo.getRideCarColors();
  }
}
