import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../requests_history/data/models/trip_model.dart';
import '../../data/models/driver_statistics_model.dart';
import '../usecases/create_rider_offer_usecase.dart';

abstract class DriverDashboardRepo {
  Future<Either<Failure, List<TripModel>>> getNewTrips();
  Future<Either<Failure, DriverStatisticsModel>> getStatistics();
 Future<Either<Failure, bool>> createOffer(
      {required CreateRiderOfferParams params});

  Future<Either<Failure, String>> acceptTrip({required String id});

}
