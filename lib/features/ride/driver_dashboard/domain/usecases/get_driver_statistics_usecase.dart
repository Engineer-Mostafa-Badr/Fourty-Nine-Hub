import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/data/models/driver_statistics_model.dart';

import '../repositories/driver_dashboard_repo.dart';

class GetDriverStatisticsUseCase
    extends UseCase<DriverStatisticsModel, NoParams> {
  final DriverDashboardRepo _repository;

  const GetDriverStatisticsUseCase(this._repository);

  @override
  Future<Either<Failure, DriverStatisticsModel>> call(NoParams params) {
    return _repository.getStatistics();
  }
}
