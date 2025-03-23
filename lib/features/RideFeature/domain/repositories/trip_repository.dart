import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/dashboards/settings_dashboard_entity.dart';
import '../entities/dashboards/trips_response_entity.dart';
import '../usecases/dashboards/update_settings_dashboard_usecase.dart';

abstract class TripRepository {
   Future<Either<Failure, TripsResponseEntity>> getAvailableTrips(String params);
   Future<Either<Failure, TripsResponseEntity>> getPastTrips(String params);
   Future<Either<Failure, SettingsDashboardEntityResponse>> getSettings();
   Future<Either<Failure, bool>> updateSettings(UpdateSettingsDashboardUsecaseParam params);
   
}