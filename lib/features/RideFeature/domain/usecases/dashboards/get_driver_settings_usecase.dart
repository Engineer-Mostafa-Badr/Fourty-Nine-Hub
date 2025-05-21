import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/driver_settings_entity.dart';
import '../../entities/dashboards/settings_dashboard_entity.dart';
import '../../repositories/trip_repository.dart';

class GetDriverSettingsUseCase extends UseCase<DriverSettingsEntity , NoParams> {
  final TripRepository repository;

  GetDriverSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, DriverSettingsEntity >> call(NoParams params) async {
    return await repository.getDriverSettings();
  }
}
