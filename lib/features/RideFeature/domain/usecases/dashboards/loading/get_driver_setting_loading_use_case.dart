import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../entities/loading/settings_driver_loading_entity.dart';
import '../../../repositories/trip_repository.dart';

class GetDriverLoadingSettingsUseCase extends UseCase<DriverSettingLoadingEntity  , NoParams> {
  final TripRepository repository;

  GetDriverLoadingSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, DriverSettingLoadingEntity   >> call(NoParams params) async {
    return await repository.getDriverLoadingSettings();
  }
}
