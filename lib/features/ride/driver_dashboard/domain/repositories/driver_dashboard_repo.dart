import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/data/models/trip_model.dart';
import '../../data/models/driver_statistics_model.dart';

abstract class DriverDashboardRepo {
  Future<Either<Failure, List<TripModel>>> getNewTrips();
  Future<Either<Failure, DriverStatisticsModel>> getStatistics();
}
