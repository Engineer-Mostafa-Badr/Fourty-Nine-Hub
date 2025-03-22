import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/settings_dashboard_entity.dart';
import '../../repositories/trip_repository.dart';

class GetSettingsDashboardUsecase extends UseCase<SettingsDashboardEntityResponse, NoParams> {
  final TripRepository repository;

  GetSettingsDashboardUsecase(this.repository);

  @override
  Future<Either<Failure, SettingsDashboardEntityResponse>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
